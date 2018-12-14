Shader "Custom/JdShader" {
      Properties {
          _Color ("Color", Color) = (1,1,1,1)
          _MainTex ("Main Texture Color", 2D) = "white" {}
          _SecondaryTex ("Overlay Texture Color Alpha (A)", 2D) = "white" {}
          _Glossiness ("Smoothness", Range(0,1)) = 0.5
          _Metallic ("Metallic", Range(0,1)) = 0.0
          _ScrollXSpeed ("X Scroll Speed", Range(0, 10)) = 2
		_ScrollYSpeed ("Y Scroll Speed", Range(0, 10)) = 2
      }
      SubShader {
          Tags { "RenderType"="Transparent"}
 
          LOD 200
          CGPROGRAM
          // Physically based Standard lighting model, and enable shadows on all light types
          #pragma surface surf Standard alpha fullforwardshadows
  
          // Use shader model 3.0 target, to get nicer looking lighting
          #pragma target 3.0
  
          sampler2D _MainTex;
          sampler2D _SecondaryTex;
          fixed _ScrollXSpeed;
		fixed _ScrollYSpeed;
  
          struct Input {
              float2 uv_MainTex;
              float2 uv_SecondTex;

              //float2 uv_SecondTex;
          };

        //   v2f vert(appdata v){
        //       v.vertex.xyz *= _OutlineWidth;	// normal

		//     v2f o;
		//     o.pos = UnityObjectToClipPos(v.vertex);		// Transforming back to world space
        //     return o;
        //   }
  
  // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)
        
          half _Glossiness;
          half _Metallic;
          fixed4 _Color;
  
          void surf (Input IN, inout SurfaceOutputStandard o) {
              // Albedo comes from a texture tinted by colora
              float4 mainTex = tex2D (_MainTex, IN.uv_MainTex);
              float4 secondTex = tex2D (_SecondaryTex, IN.uv_SecondTex);
              float4 overlayTex = tex2D (_SecondaryTex, IN.uv_MainTex);
              half3 mainTexVisible = mainTex.rgb * (1-overlayTex.a);
              half3 overlayTexVisible = overlayTex.rgb * (overlayTex.a);
              // Create a separate variable to store out UVs before we pass them to the tex2D function
			fixed2 scrolledUV = IN.uv_SecondTex;
            // Create variables that store the individual x and y components for the UVs scaled by time
			fixed xScrollValue = _ScrollXSpeed * _Time;
			fixed yScrollValue = _ScrollYSpeed * _Time;
             
         float3 finalColor = (mainTexVisible + overlayTexVisible) * _Color;
			
            scrolledUV += fixed2(xScrollValue, yScrollValue);
             // Apply UV offset
            half4 c = tex2D(_SecondaryTex, scrolledUV);
              o.Albedo = finalColor.rgb;
              // Metallic and smoothness come from slider variables
              o.Metallic = _Metallic;
              o.Smoothness = _Glossiness;
              // o.Alpha = 0.5 * ( mainTex.a + overlayTex.a );
            o.Alpha = c.a;
          }
          ENDCG
      } 
      FallBack "Diffuse"
  }