Shader "Unlit/EdgeShader"
{
	
	Properties
	{
		
		_MainTex ("Texture", 2D) = "White" {}
		_OutlineColor("Outline color", Color) = (0,0,0,1)	// Black color
		_OutlineWidth("Outline width", Range(1.0,5.0)) = 1.01
	}

	CGINCLUDE
	#include "UnityCG.cginc"

	struct appdata{
		float4 vertex : POSITION;
		float3 normal : NORMAL;
		float2 uv : TEXCOORD0;
	};

	struct v2f{
		float4 pos : POSITION;
		// float4 color : COLOR;
		float3 normal : NORMAL;
		float2 uv : TEXCOORD0;
	};

	float _OutlineWidth;
	float4 _OutlineColor;
	sampler2D _MainTex;
	float4 _MainTex_ST;

	v2f vert(appdata v){
		v.vertex.xyz *= _OutlineWidth;	// normal

		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);		// Transforming back to world space
		o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		// o.color = _OutlineColor;
		return o;

	}

	ENDCG // Closing CG

	SubShader
	{
		Tags { "Queue" = "Transparent"}
		
		Pass 	// For Rendering the Outline
		{
			ZWrite Off		// So cannot write on Depth buffer. Other things will be on top of it

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		half4 frag(v2f i) : COLOR
		{
			return _OutlineColor;
		}
		ENDCG
		}

		Pass 	// Normal Render
		{
			ZWrite On

			Material{
				Diffuse[_Color]
				Ambient[_Color]
			}

			Lighting On

			SetTexture[_MainTex]{
				ConstantColor[_Color]
			}

			SetTexture[_MainTex]{
				Combine previous * primary DOUBLE
			}
		}

		//  Pass
		//  {
		//  	ZWrite On

		//  	CGPROGRAM
		//  	#pragma vertex vert
		//  	#pragma fragment frag

		//  	fixed4 frag (v2f i) : SV_Target
		//  	{
		//  		// sample the texture
		//  		fixed4 col = tex2D(_MainTex, i.uv);
		//  		return col;
		//  	}
		//  	ENDCG
		//  }
	}

		
}
