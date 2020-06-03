// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KortyBoi/Realistic/Standard+"
{
	Properties
	{
		_MainColor("Main Color", Color) = (1,1,1,0)
		_MainTex("MainTex", 2D) = "white" {}
		_Contrast("Contrast", Range( -2 , 2)) = 1
		[Normal]_Normal("Normal", 2D) = "white" {}
		_NormalIntensity("Normal Intensity", Range( -2 , 2)) = 1
		
		//[Space(10}]
		[Toggle]_Emission("Emission", Float) = 0
		_EmissionColor("Emission Color", Color) = (0.003921569,0.003921569,0.003921569,0)
		_EmissionValue("Emission Value", Range( -1 , 2)) = 0.1
		_EmissionTex("EmissionTex", 2D) = "white" {}
		[Toggle]_EmissionShift("Emission Shift", Float) = 0
		_ShiftValue("Shift Value", Range( -1 , 2)) = 0.1
		_ColorShift1("Color Shift 1", Color) = (1,0,0,0)
		_ColorShift2("Color Shfit 2", Color) = (0,0,1,0)
		_ShiftPausessec("Shift Pauses /sec", Range( 0 , 2)) = 1
		_OutlineWidth( "Outline Width", Float ) = 0
		_OutlineColor( "Outline Color", Color ) = (0,0,0,0)
		
		//[Space(10}]
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[Toggle]_ExtraSmooth("Extra Smooth?", Float) = 0
		_ExtraSmoothness("Extra Smoothness", Range( 0 , 10)) = 1
		[Toggle]_IsMatallic("Is Matallic?", Float) = 0
		_Metalness("Metalness", Range( 0 , 1)) = 0
		[Toggle]_ToggleAmbientOcclusion("Toggle Ambient Occlusion", Float) = 0
		_AmbientOcclusionStrength("Ambient Occlusion Strength", Float) = -2
		
		//[Space(10}]
		[Toggle]_ToggleTransluency("Toggle Transluency", Float) = 0
		//[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		
		
		struct Input {
			half filler;
		};
		float4 _OutlineColor;
		float _OutlineWidth;
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz *= ( 1 + _OutlineWidth);
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _OutlineColor.rgb;
			o.Alpha = 1;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		LOD 100
		Cull Off
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#pragma target 4.6
		#pragma surface surf StandardCustom keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		struct SurfaceOutputStandardCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			half3 Translucency;
		};

		uniform float _NormalIntensity;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float _Contrast;
		uniform float4 _MainColor;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _Emission;
		uniform sampler2D _EmissionTex;
		uniform float4 _EmissionTex_ST;
		uniform float _EmissionShift;
		uniform float _EmissionValue;
		uniform float4 _EmissionColor;
		uniform float _ShiftValue;
		uniform float4 _ColorShift1;
		uniform float4 _ColorShfit2;
		uniform float _ShiftPausessec;
		uniform float _IsMatallic;
		uniform float _Metalness;
		uniform float _Smoothness;
		uniform float _ExtraSmooth;
		uniform float _ExtraSmoothness;
		uniform float _ToggleAmbientOcclusion;
		uniform float _AmbientOcclusionStrength;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform float _ToggleTransluency;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		inline half4 LightingStandardCustom(SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
		{
			#if !DIRECTIONAL
			float3 lightAtten = gi.light.color;
			#else
			float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, _TransShadow );
			#endif
			half3 lightDir = gi.light.dir + s.Normal * _TransNormalDistortion;
			half transVdotL = pow( saturate( dot( viewDir, -lightDir ) ), _TransScattering );
			half3 translucency = lightAtten * (transVdotL * _TransDirect + gi.indirect.diffuse * _TransAmbient) * s.Translucency;
			half4 c = half4( s.Albedo * translucency * _Translucency, 0 );

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + c;
		}

		inline void LightingStandardCustom_GI(SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
		{
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _Normal, uv_Normal ), _NormalIntensity );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 temp_output_87_0 = ( float4( 0,0,0,0 ) + ( CalculateContrast(_Contrast,_MainColor) + tex2D( _MainTex, uv_MainTex ) ) );
			o.Albedo = temp_output_87_0.rgb;
			float4 temp_cast_1 = (0.0).xxxx;
			float2 uv_EmissionTex = i.uv_texcoord * _EmissionTex_ST.xy + _EmissionTex_ST.zw;
			float4 lerpResult64 = lerp( ( _ShiftValue + _ColorShift1 ) , ( _ShiftValue + _ColorShfit2 ) , ( sin( _Time.y ) + _ShiftPausessec ));
			o.Emission = (( _Emission )?( ( tex2D( _EmissionTex, uv_EmissionTex ) * (( _EmissionShift )?( lerpResult64 ):( ( _EmissionValue + _EmissionColor ) )) ) ):( temp_cast_1 )).rgb;
			o.Metallic = (( _IsMatallic )?( _Metalness ):( 0.0 ));
			o.Smoothness = ( _Smoothness + (( _ExtraSmooth )?( _ExtraSmoothness ):( 0.0 )) );
			o.Occlusion = (( _ToggleAmbientOcclusion )?( _AmbientOcclusionStrength ):( 0.0 ));
			float4 temp_cast_3 = (0.0).xxxx;
			o.Translucency = (( _ToggleTransluency )?( temp_output_87_0 ):( temp_cast_3 )).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Standard"
	//CustomEditor "ASEMaterialInspector"
	CustomEditor "StandardPlusEditor"
}