Shader "Custom/Caustics" {

	Properties{

		_Speed("Speed", Float) = 0.5

	}

	CGINCLUDE

	#include "UnityCustomRenderTexture.cginc"

	float _Speed;

	float4 frag(v2f_customrendertexture data) : SV_Target {
		float2 uv = data.globalTexcoord;

		float time = _Time.z * _Speed;

		float TAU = 6.28318530718;
		int MAX_ITER = 5;

		float2 p = fmod(uv * TAU, TAU) - 250.0;

		float2 i = p;
		float c = 1.0;
		float inten = 0.005;

		for (int n = 0; n < MAX_ITER; n++) {
			float t = time * (1.0 - (3.5 / float(n + 1)));
			i = p + float2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));
			c += 1.0 / length(float2(p.x / (sin(i.x + t) / inten), p.y / (cos(i.y + t) / inten)));
		}

		c /= float(MAX_ITER);
		c = 1.17 - pow(c, 1.4);
		
		float4 colour = (float4)pow(abs(c), 8.0);

		//colour = clamp(colour + float3(0.0, 0.35, 0.5), 0.0, 1.0);

		return float4(colour);
	}

	ENDCG

	SubShader {

		Cull Off ZWrite Off ZTest Always
		
		Pass {
			Name "Update"
			
			Tags {"RenderType"="Transparent" "Queue"="Transparent"}

			CGPROGRAM
			
			#pragma vertex CustomRenderTextureVertexShader
			#pragma fragment frag
			
			ENDCG
		}
	}

}