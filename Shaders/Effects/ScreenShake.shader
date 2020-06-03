// Made with Amplify Shader Editor
Shader "KortyBoi/Effects/ScreenShake"
{
	Properties
	{
		_Shake_Power("Shake_Power", Range( 0 , 2000)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Overlay+0" "IsEmissive" = "true"  }
		Cull Front
		ZTest Always
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 screenPos;
		};

		uniform sampler2D _GrabTexture;
		uniform float _Shake_Power;

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPos13 = ase_screenPos;
			#if UNITY_UV_STARTS_AT_TOP
			float scale13 = -1.0;
			#else
			float scale13 = 1.0;
			#endif
			float halfPosW13 = ase_screenPos13.w * 0.5;
			ase_screenPos13.y = ( ase_screenPos13.y - halfPosW13 ) * _ProjectionParams.x* scale13 + halfPosW13;
			ase_screenPos13.xyzw /= ase_screenPos13.w;
			float mulTime32 = _Time.y * _Shake_Power;
			float4 screenColor10 = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD( ( ase_screenPos13 + ( sin( mulTime32 ) / 100 ) ) ) );
			o.Emission = screenColor10.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14101
179;292;1391;648;1465.662;325.5042;1.373106;True;True
Node;AmplifyShaderEditor.RangedFloatNode;36;-1038.922,301.3792;Float;False;Property;_Shake_Power;Shake_Power;1;0;Create;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;32;-1018.326,143.472;Float;False;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;33;-843.9409,135.2333;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;30;-691.5261,110.5174;Float;False;2;0;FLOAT;0,0,0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;13;-1018.326,-173.2971;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-588.5436,-42.8519;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;10;-371.5036,-58.49281;Float;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;Object;-1;False;1;0;FLOAT4;0,0,0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;5;-22,1;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;ScreenShake;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Front;0;7;False;0;0;Custom;0.5;True;True;0;True;Opaque;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;32;0;36;0
WireConnection;33;0;32;0
WireConnection;30;0;33;0
WireConnection;27;0;13;0
WireConnection;27;1;30;0
WireConnection;10;0;27;0
WireConnection;5;2;10;0
ASEEND*/
//CHKSM=0FD9A653BBAF09584EA014F0A07CECE40099B0AA