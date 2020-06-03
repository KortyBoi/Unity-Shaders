// Shader created with Shader Forge v1.38 - by Kortana#4110

Shader "KortyBoi/Toon/Water" {
    Properties {
        _color_water_1 ("color_water_1", Color) = (1,1,1,1)
        _color_water_2 ("color_water_2", Color) = (0,0,0,1)
        _Posterize_step ("Posterize_step", Float ) = 10
        _Specular ("Specular", Range(0, 1)) = 0.542735
        _Height_factor ("Height_factor", Float ) = 0.001
        _Tesselation ("Tesselation", Float ) = 1
        _color_foam ("color_foam", Color) = (0.9338235,0.9972616,1,1)
        _foam_white_width ("foam_white_width", Float ) = 0
        _Foam_Albedo ("Foam_Albedo", 2D) = "white" {}
        _opacity_foam_width ("opacity_foam_width", Float ) = 12
        _Foam_width ("Foam_width", Float ) = 1
        _FoamSpeed_x1y1x2y2 ("FoamSpeed_x1y1x2y2", Vector) = (0.02,0.02,0.02,0.02)
        _Normal ("Normal", 2D) = "bump" {}
        _NRMIntensity ("NRM Intensity", Range(0, 1)) = 0
        _WaveSpeedx1y1x2y2 ("WaveSpeed x1y1x2y2", Vector) = (0.05,0.05,0.05,0.05)
        _WaveSmallSpeedx1y1x2y2 ("WaveSmallSpeed x1y1x2y2", Vector) = (0.1,0.1,0.1,0.1)
        _offoceancolor ("off ocean color", Color) = (0.5,0.5,0.5,1)
        _Opacityofftheocean ("Opacity / off the ocean", Range(0, 1)) = 0.95
        _off_ocean_depth ("off_ocean_depth", Float ) = 12
        _SeaSidedeep ("SeaSide deep", Color) = (0,0.2862745,0.427451,1)
        _SeaSide_deep_width ("SeaSide_deep_width", Float ) = 12
        _SeaSide_color ("SeaSide_color", Color) = (0.5,0.5,0.5,1)
        _SeaSide_width ("SeaSide_width", Float ) = 15
        _OpacitySeaside ("Opacity / Sea side", Range(0, 1)) = 0.1
        _Height_Disp ("Height_Disp", 2D) = "white" {}
        _Refraction ("Refraction", Float ) = 0
        _NRM_None ("NRM_None", 2D) = "bump" {}
        _mask_foam ("mask_foam", 2D) = "white" {}
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        GrabPass{ }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
			Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x n3ds wiiu 
            #pragma target 2.0
            uniform sampler2D _GrabTexture;
            uniform sampler2D _CameraDepthTexture;
            uniform sampler2D _Height_Disp; uniform float4 _Height_Disp_ST;
            uniform float4 _color_water_1;
            uniform float _SeaSide_width;
            uniform float4 _color_water_2;
            uniform float4 _color_foam;
            uniform float _Posterize_step;
            uniform float _opacity_foam_width;
            uniform float _SeaSide_deep_width;
            uniform float4 _SeaSidedeep;
            uniform float _Foam_width;
            uniform sampler2D _Normal; uniform float4 _Normal_ST;
            uniform float _Refraction;
            uniform sampler2D _Foam_Albedo; uniform float4 _Foam_Albedo_ST;
            uniform float4 _FoamSpeed_x1y1x2y2;
            uniform float4 _WaveSpeedx1y1x2y2;
            uniform float4 _WaveSmallSpeedx1y1x2y2;
            uniform float _Opacityofftheocean;
            uniform float _OpacitySeaside;
            uniform float _Specular;
            uniform float _NRMIntensity;
            uniform float _foam_white_width;
            uniform sampler2D _NRM_None; uniform float4 _NRM_None_ST;
            uniform float4 _offoceancolor;
            uniform float _off_ocean_depth;
            uniform float4 _SeaSide_color;
            uniform sampler2D _mask_foam; uniform float4 _mask_foam_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                float3 normalDir : TEXCOORD4;
                float3 tangentDir : TEXCOORD5;
                float3 bitangentDir : TEXCOORD6;
                float4 projPos : TEXCOORD7;
                UNITY_FOG_COORDS(8)
                #if defined(LIGHTMAP_ON) || defined(UNITY_SHOULD_SAMPLE_SH)
                    float4 ambientOrLightmapUV : TEXCOORD9;
                #endif
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                #ifdef LIGHTMAP_ON
                    o.ambientOrLightmapUV.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                    o.ambientOrLightmapUV.zw = 0;
                #endif
                #ifdef DYNAMICLIGHTMAP_ON
                    o.ambientOrLightmapUV.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                #endif
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                float3 _NRM_None_var = UnpackNormal(tex2D(_NRM_None,TRANSFORM_TEX(i.uv0, _NRM_None)));
                float4 node_9880 = _Time;
                float2 node_1049 = (float2(_WaveSpeedx1y1x2y2.b,_WaveSpeedx1y1x2y2.a)*node_9880.g);
                float2 node_7254 = ((float2(0.2,0.2)*i.uv0)+node_1049);
                float3 node_8418 = UnpackNormal(tex2D(_Normal,TRANSFORM_TEX(node_7254, _Normal)));
                float4 node_6686 = _Time;
                float2 node_7493 = ((float2(0.3,0.3)*i.uv0)+(float2(_WaveSpeedx1y1x2y2.r,_WaveSpeedx1y1x2y2.g)*node_6686.g));
                float3 node_9954 = UnpackNormal(tex2D(_Normal,TRANSFORM_TEX(node_7493, _Normal)));
                float3 node_8215_nrm_base = node_8418.rgb + float3(0,0,1);
                float3 node_8215_nrm_detail = node_9954.rgb * float3(-1,-1,1);
                float3 node_8215_nrm_combined = node_8215_nrm_base*dot(node_8215_nrm_base, node_8215_nrm_detail)/node_8215_nrm_base.z - node_8215_nrm_detail;
                float3 node_8215 = node_8215_nrm_combined;
                float4 node_2541 = _Time;
                float2 node_2429 = ((float2(1.8,1.8)*i.uv0)+(float2(_WaveSmallSpeedx1y1x2y2.r,_WaveSmallSpeedx1y1x2y2.g)*sin(node_2541.g)));
                float3 node_287 = UnpackNormal(tex2D(_Normal,TRANSFORM_TEX(node_2429, _Normal)));
                float4 node_7772 = _Time;
                float2 node_3409 = (i.uv0+(float2(_WaveSmallSpeedx1y1x2y2.b,_WaveSmallSpeedx1y1x2y2.a)*sin(node_7772.g)));
                float3 node_4086 = UnpackNormal(tex2D(_Normal,TRANSFORM_TEX(node_3409, _Normal)));
                float3 node_343_nrm_base = node_287.rgb + float3(0,0,1);
                float3 node_343_nrm_detail = node_4086.rgb * float3(-1,-1,1);
                float3 node_343_nrm_combined = node_343_nrm_base*dot(node_343_nrm_base, node_343_nrm_detail)/node_343_nrm_base.z - node_343_nrm_detail;
                float3 node_343 = node_343_nrm_combined;
                float3 node_1589_nrm_base = node_8215 + float3(0,0,1);
                float3 node_1589_nrm_detail = node_343 * float3(-1,-1,1);
                float3 node_1589_nrm_combined = node_1589_nrm_base*dot(node_1589_nrm_base, node_1589_nrm_detail)/node_1589_nrm_base.z - node_1589_nrm_detail;
                float3 node_1589 = node_1589_nrm_combined;
                float2 sceneUVs = (i.projPos.xy / i.projPos.w) + (_Refraction*lerp(_NRM_None_var.rgb,node_1589,_NRMIntensity)*i.normalDir).rg;
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = 1;
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float gloss = 1.0 - 0.5; // Convert roughness to gloss
                float specPow = exp2( gloss * 10.0 + 1.0 );
/////// GI Data:
                UnityLight light;
                #ifdef LIGHTMAP_OFF
                    light.color = lightColor;
                    light.dir = lightDirection;
                    light.ndotl = LambertTerm (normalDirection, light.dir);
                #else
                    light.color = half3(0.f, 0.f, 0.f);
                    light.ndotl = 0.0f;
                    light.dir = half3(0.f, 0.f, 0.f);
                #endif
                UnityGIInput d;
                d.light = light;
                d.worldPos = i.posWorld.xyz;
                d.worldViewDir = viewDirection;
                d.atten = attenuation;
                #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
                    d.ambient = 0;
                    d.lightmapUV = i.ambientOrLightmapUV;
                #else
                    d.ambient = i.ambientOrLightmapUV;
                #endif
                #if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMin[0] = unity_SpecCube0_BoxMin;
                    d.boxMin[1] = unity_SpecCube1_BoxMin;
                #endif
                #if UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMax[0] = unity_SpecCube0_BoxMax;
                    d.boxMax[1] = unity_SpecCube1_BoxMax;
                    d.probePosition[0] = unity_SpecCube0_ProbePosition;
                    d.probePosition[1] = unity_SpecCube1_ProbePosition;
                #endif
                d.probeHDR[0] = unity_SpecCube0_HDR;
                d.probeHDR[1] = unity_SpecCube1_HDR;
                Unity_GlossyEnvironmentData ugls_en_data;
                ugls_en_data.roughness = 1.0 - gloss;
                ugls_en_data.reflUVW = viewReflectDirection;
                UnityGI gi = UnityGlobalIllumination(d, 1, normalDirection, ugls_en_data );
                lightDirection = gi.light.dir;
                lightColor = gi.light.color;
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float3 specularColor = float3(_Specular,_Specular,_Specular);
                float specularMonochrome = max( max(specularColor.r, specularColor.g), specularColor.b);
                float normTerm = (specPow + 8.0 ) / (8.0 * Pi);
                float3 directSpecular = attenColor * pow(max(0,dot(halfDirection,normalDirection)),specPow)*normTerm*specularColor;
                float3 indirectSpecular = (gi.indirect.specular)*specularColor;
                float3 specular = (directSpecular + indirectSpecular);
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += gi.indirect.diffuse;
                float node_1994 = 1.0;
                float4 node_8144 = tex2D(_Height_Disp,TRANSFORM_TEX(node_2429, _Height_Disp));
                float4 _Height_2 = tex2D(_Height_Disp,TRANSFORM_TEX(node_3409, _Height_Disp));
                float2 node_92 = (float2(2,2)*i.uv0);
                float2 node_2262 = ((float2(0.3,0.3)*node_92)+node_1049);
                float4 node_4093 = tex2D(_Height_Disp,TRANSFORM_TEX(node_2262, _Height_Disp));
                float2 node_1899 = ((float2(0.2,0.2)*node_92)+node_1049);
                float4 node_6609 = tex2D(_Height_Disp,TRANSFORM_TEX(node_1899, _Height_Disp));
                float3 node_6382 = saturate(( (node_4093.rgb+node_6609.rgb) > 0.5 ? (1.0-(1.0-2.0*((node_4093.rgb+node_6609.rgb)-0.5))*(1.0-(node_8144.rgb+_Height_2.rgb))) : (2.0*(node_4093.rgb+node_6609.rgb)*(node_8144.rgb+_Height_2.rgb)) ));
                float4 _mask_foam_var = tex2D(_mask_foam,TRANSFORM_TEX(i.uv0, _mask_foam));
                float3 diffuseColor = (1.0-(1.0-lerp(_color_foam.rgb,(lerp(_SeaSidedeep.rgb,float3(node_1994,node_1994,node_1994),saturate((sceneZ-partZ)/_SeaSide_deep_width))*lerp(_SeaSide_color.rgb,_offoceancolor.rgb,saturate((sceneZ-partZ)/_off_ocean_depth))),saturate((sceneZ-partZ)/_Foam_width)))*(1.0-lerp(floor(lerp(_color_water_2.rgb,_color_water_1.rgb,node_6382) * _Posterize_step) / (_Posterize_step - 1),_color_water_2.rgb,_mask_foam_var.r)));
                diffuseColor *= 1-specularMonochrome;
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse + specular;
                float4 node_4576 = _Time;
                float node_817 = sin(node_4576.g);
                float2 node_8410 = ((float2(1,1)*i.uv0)+(float2(_FoamSpeed_x1y1x2y2.r,_FoamSpeed_x1y1x2y2.g)*node_817));
                float4 node_5485 = tex2D(_Foam_Albedo,TRANSFORM_TEX(node_8410, _Foam_Albedo));
                float2 node_3400 = ((i.uv0*float2(0.8,0.8))+(node_817*float2(_FoamSpeed_x1y1x2y2.b,_FoamSpeed_x1y1x2y2.a)));
                float4 node_6872 = tex2D(_Foam_Albedo,TRANSFORM_TEX(node_3400, _Foam_Albedo));
                float node_6677 = saturate((node_5485.a*node_6872.a));
                fixed4 finalRGBA = fixed4(lerp(sceneColor.rgb, finalColor,lerp(saturate(lerp(_color_foam.rgb,float3(node_6677,node_6677,node_6677),saturate((sceneZ-partZ)/_foam_white_width))).r,lerp(_OpacitySeaside,_Opacityofftheocean,saturate((sceneZ-partZ)/_SeaSide_width)),saturate((sceneZ-partZ)/_opacity_foam_width))),1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdadd
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x n3ds wiiu 
            #pragma target 2.0
            uniform sampler2D _GrabTexture;
            uniform sampler2D _CameraDepthTexture;
            uniform sampler2D _Height_Disp; uniform float4 _Height_Disp_ST;
            uniform float4 _color_water_1;
            uniform float _SeaSide_width;
            uniform float4 _color_water_2;
            uniform float4 _color_foam;
            uniform float _Posterize_step;
            uniform float _opacity_foam_width;
            uniform float _SeaSide_deep_width;
            uniform float4 _SeaSidedeep;
            uniform float _Foam_width;
            uniform sampler2D _Normal; uniform float4 _Normal_ST;
            uniform float _Refraction;
            uniform sampler2D _Foam_Albedo; uniform float4 _Foam_Albedo_ST;
            uniform float4 _FoamSpeed_x1y1x2y2;
            uniform float4 _WaveSpeedx1y1x2y2;
            uniform float4 _WaveSmallSpeedx1y1x2y2;
            uniform float _Opacityofftheocean;
            uniform float _OpacitySeaside;
            uniform float _Specular;
            uniform float _NRMIntensity;
            uniform float _foam_white_width;
            uniform sampler2D _NRM_None; uniform float4 _NRM_None_ST;
            uniform float4 _offoceancolor;
            uniform float _off_ocean_depth;
            uniform float4 _SeaSide_color;
            uniform sampler2D _mask_foam; uniform float4 _mask_foam_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                float3 normalDir : TEXCOORD4;
                float3 tangentDir : TEXCOORD5;
                float3 bitangentDir : TEXCOORD6;
                float4 projPos : TEXCOORD7;
                LIGHTING_COORDS(8,9)
                UNITY_FOG_COORDS(10)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                float3 _NRM_None_var = UnpackNormal(tex2D(_NRM_None,TRANSFORM_TEX(i.uv0, _NRM_None)));
                float4 node_9880 = _Time;
                float2 node_1049 = (float2(_WaveSpeedx1y1x2y2.b,_WaveSpeedx1y1x2y2.a)*node_9880.g);
                float2 node_7254 = ((float2(0.2,0.2)*i.uv0)+node_1049);
                float3 node_8418 = UnpackNormal(tex2D(_Normal,TRANSFORM_TEX(node_7254, _Normal)));
                float4 node_6686 = _Time;
                float2 node_7493 = ((float2(0.3,0.3)*i.uv0)+(float2(_WaveSpeedx1y1x2y2.r,_WaveSpeedx1y1x2y2.g)*node_6686.g));
                float3 node_9954 = UnpackNormal(tex2D(_Normal,TRANSFORM_TEX(node_7493, _Normal)));
                float3 node_8215_nrm_base = node_8418.rgb + float3(0,0,1);
                float3 node_8215_nrm_detail = node_9954.rgb * float3(-1,-1,1);
                float3 node_8215_nrm_combined = node_8215_nrm_base*dot(node_8215_nrm_base, node_8215_nrm_detail)/node_8215_nrm_base.z - node_8215_nrm_detail;
                float3 node_8215 = node_8215_nrm_combined;
                float4 node_2541 = _Time;
                float2 node_2429 = ((float2(1.8,1.8)*i.uv0)+(float2(_WaveSmallSpeedx1y1x2y2.r,_WaveSmallSpeedx1y1x2y2.g)*sin(node_2541.g)));
                float3 node_287 = UnpackNormal(tex2D(_Normal,TRANSFORM_TEX(node_2429, _Normal)));
                float4 node_7772 = _Time;
                float2 node_3409 = (i.uv0+(float2(_WaveSmallSpeedx1y1x2y2.b,_WaveSmallSpeedx1y1x2y2.a)*sin(node_7772.g)));
                float3 node_4086 = UnpackNormal(tex2D(_Normal,TRANSFORM_TEX(node_3409, _Normal)));
                float3 node_343_nrm_base = node_287.rgb + float3(0,0,1);
                float3 node_343_nrm_detail = node_4086.rgb * float3(-1,-1,1);
                float3 node_343_nrm_combined = node_343_nrm_base*dot(node_343_nrm_base, node_343_nrm_detail)/node_343_nrm_base.z - node_343_nrm_detail;
                float3 node_343 = node_343_nrm_combined;
                float3 node_1589_nrm_base = node_8215 + float3(0,0,1);
                float3 node_1589_nrm_detail = node_343 * float3(-1,-1,1);
                float3 node_1589_nrm_combined = node_1589_nrm_base*dot(node_1589_nrm_base, node_1589_nrm_detail)/node_1589_nrm_base.z - node_1589_nrm_detail;
                float3 node_1589 = node_1589_nrm_combined;
                float2 sceneUVs = (i.projPos.xy / i.projPos.w) + (_Refraction*lerp(_NRM_None_var.rgb,node_1589,_NRMIntensity)*i.normalDir).rg;
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float gloss = 1.0 - 0.5; // Convert roughness to gloss
                float specPow = exp2( gloss * 10.0 + 1.0 );
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float3 specularColor = float3(_Specular,_Specular,_Specular);
                float specularMonochrome = max( max(specularColor.r, specularColor.g), specularColor.b);
                float normTerm = (specPow + 8.0 ) / (8.0 * Pi);
                float3 directSpecular = attenColor * pow(max(0,dot(halfDirection,normalDirection)),specPow)*normTerm*specularColor;
                float3 specular = directSpecular;
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float node_1994 = 1.0;
                float4 node_8144 = tex2D(_Height_Disp,TRANSFORM_TEX(node_2429, _Height_Disp));
                float4 _Height_2 = tex2D(_Height_Disp,TRANSFORM_TEX(node_3409, _Height_Disp));
                float2 node_92 = (float2(2,2)*i.uv0);
                float2 node_2262 = ((float2(0.3,0.3)*node_92)+node_1049);
                float4 node_4093 = tex2D(_Height_Disp,TRANSFORM_TEX(node_2262, _Height_Disp));
                float2 node_1899 = ((float2(0.2,0.2)*node_92)+node_1049);
                float4 node_6609 = tex2D(_Height_Disp,TRANSFORM_TEX(node_1899, _Height_Disp));
                float3 node_6382 = saturate(( (node_4093.rgb+node_6609.rgb) > 0.5 ? (1.0-(1.0-2.0*((node_4093.rgb+node_6609.rgb)-0.5))*(1.0-(node_8144.rgb+_Height_2.rgb))) : (2.0*(node_4093.rgb+node_6609.rgb)*(node_8144.rgb+_Height_2.rgb)) ));
                float4 _mask_foam_var = tex2D(_mask_foam,TRANSFORM_TEX(i.uv0, _mask_foam));
                float3 diffuseColor = (1.0-(1.0-lerp(_color_foam.rgb,(lerp(_SeaSidedeep.rgb,float3(node_1994,node_1994,node_1994),saturate((sceneZ-partZ)/_SeaSide_deep_width))*lerp(_SeaSide_color.rgb,_offoceancolor.rgb,saturate((sceneZ-partZ)/_off_ocean_depth))),saturate((sceneZ-partZ)/_Foam_width)))*(1.0-lerp(floor(lerp(_color_water_2.rgb,_color_water_1.rgb,node_6382) * _Posterize_step) / (_Posterize_step - 1),_color_water_2.rgb,_mask_foam_var.r)));
                diffuseColor *= 1-specularMonochrome;
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse + specular;
                float4 node_4576 = _Time;
                float node_817 = sin(node_4576.g);
                float2 node_8410 = ((float2(1,1)*i.uv0)+(float2(_FoamSpeed_x1y1x2y2.r,_FoamSpeed_x1y1x2y2.g)*node_817));
                float4 node_5485 = tex2D(_Foam_Albedo,TRANSFORM_TEX(node_8410, _Foam_Albedo));
                float2 node_3400 = ((i.uv0*float2(0.8,0.8))+(node_817*float2(_FoamSpeed_x1y1x2y2.b,_FoamSpeed_x1y1x2y2.a)));
                float4 node_6872 = tex2D(_Foam_Albedo,TRANSFORM_TEX(node_3400, _Foam_Albedo));
                float node_6677 = saturate((node_5485.a*node_6872.a));
                fixed4 finalRGBA = fixed4(finalColor * lerp(saturate(lerp(_color_foam.rgb,float3(node_6677,node_6677,node_6677),saturate((sceneZ-partZ)/_foam_white_width))).r,lerp(_OpacitySeaside,_Opacityofftheocean,saturate((sceneZ-partZ)/_SeaSide_width)),saturate((sceneZ-partZ)/_opacity_foam_width)),0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "Meta"
            Tags {
                "LightMode"="Meta"
            }
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_META 1
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #include "UnityMetaPass.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x n3ds wiiu 
            #pragma target 2.0
            uniform sampler2D _CameraDepthTexture;
            uniform sampler2D _Height_Disp; uniform float4 _Height_Disp_ST;
            uniform float4 _color_water_1;
            uniform float4 _color_water_2;
            uniform float4 _color_foam;
            uniform float _Posterize_step;
            uniform float _SeaSide_deep_width;
            uniform float4 _SeaSidedeep;
            uniform float _Foam_width;
            uniform float4 _WaveSpeedx1y1x2y2;
            uniform float4 _WaveSmallSpeedx1y1x2y2;
            uniform float _Specular;
            uniform float4 _offoceancolor;
            uniform float _off_ocean_depth;
            uniform float4 _SeaSide_color;
            uniform sampler2D _mask_foam; uniform float4 _mask_foam_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                float4 projPos : TEXCOORD4;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i) : SV_Target {
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                UnityMetaInput o;
                UNITY_INITIALIZE_OUTPUT( UnityMetaInput, o );
                
                o.Emission = 0;
                
                float node_1994 = 1.0;
                float4 node_2541 = _Time;
                float2 node_2429 = ((float2(1.8,1.8)*i.uv0)+(float2(_WaveSmallSpeedx1y1x2y2.r,_WaveSmallSpeedx1y1x2y2.g)*sin(node_2541.g)));
                float4 node_8144 = tex2D(_Height_Disp,TRANSFORM_TEX(node_2429, _Height_Disp));
                float4 node_7772 = _Time;
                float2 node_3409 = (i.uv0+(float2(_WaveSmallSpeedx1y1x2y2.b,_WaveSmallSpeedx1y1x2y2.a)*sin(node_7772.g)));
                float4 _Height_2 = tex2D(_Height_Disp,TRANSFORM_TEX(node_3409, _Height_Disp));
                float2 node_92 = (float2(2,2)*i.uv0);
                float4 node_9880 = _Time;
                float2 node_1049 = (float2(_WaveSpeedx1y1x2y2.b,_WaveSpeedx1y1x2y2.a)*node_9880.g);
                float2 node_2262 = ((float2(0.3,0.3)*node_92)+node_1049);
                float4 node_4093 = tex2D(_Height_Disp,TRANSFORM_TEX(node_2262, _Height_Disp));
                float2 node_1899 = ((float2(0.2,0.2)*node_92)+node_1049);
                float4 node_6609 = tex2D(_Height_Disp,TRANSFORM_TEX(node_1899, _Height_Disp));
                float3 node_6382 = saturate(( (node_4093.rgb+node_6609.rgb) > 0.5 ? (1.0-(1.0-2.0*((node_4093.rgb+node_6609.rgb)-0.5))*(1.0-(node_8144.rgb+_Height_2.rgb))) : (2.0*(node_4093.rgb+node_6609.rgb)*(node_8144.rgb+_Height_2.rgb)) ));
                float4 _mask_foam_var = tex2D(_mask_foam,TRANSFORM_TEX(i.uv0, _mask_foam));
                float3 diffColor = (1.0-(1.0-lerp(_color_foam.rgb,(lerp(_SeaSidedeep.rgb,float3(node_1994,node_1994,node_1994),saturate((sceneZ-partZ)/_SeaSide_deep_width))*lerp(_SeaSide_color.rgb,_offoceancolor.rgb,saturate((sceneZ-partZ)/_off_ocean_depth))),saturate((sceneZ-partZ)/_Foam_width)))*(1.0-lerp(floor(lerp(_color_water_2.rgb,_color_water_1.rgb,node_6382) * _Posterize_step) / (_Posterize_step - 1),_color_water_2.rgb,_mask_foam_var.r)));
                float3 specColor = float3(_Specular,_Specular,_Specular);
                o.Albedo = diffColor + specColor * 0.125; // No gloss connected. Assume it's 0.5
                
                return UnityMetaFragment( o );
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "WaterToonEditor"
}
