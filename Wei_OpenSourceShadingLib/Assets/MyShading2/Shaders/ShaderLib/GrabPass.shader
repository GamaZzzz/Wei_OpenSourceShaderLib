﻿Shader "ShaderLib/GrabPass" {
	Properties {
		_ZoomVal("Zoom value", Range(0, 20)) = 0
	}
	SubShader {
		GrabPass{ "_GrabTexture" }
		Pass{
			Tags{ "Queue" = "Transparent" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			struct v2f {
				half4 pos : SV_POSITION;
				half4 grabPos : TEXCOORD0;
			};

			sampler2D _GrabTexture;
			half _ZoomVal;

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.grabPos = ComputeGrabScreenPos(o.pos + half4(0, 0, 0, _ZoomVal));
				return o;
			}

			half4 frag(v2f i) : COLOR{
				fixed4 color = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.grabPos));
				fixed val = (color.x + color.y + color.z) / 3;
				return fixed4(val, val, val, color.a);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
/*
	https://docs.unity3d.com/Manual/SL-GrabPass.html

	The GrabPass belongs inside a subshader
*/