// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AdultLink/HoloShield"
{
	Properties
	{
		_Globalopacity("Global opacity", Range( 0 , 1)) = 1
		_Maintexture("Main texture", 2D) = "white" {}
		_Maintextureintensity("Main texture intensity", Float) = 1
		_Mainpanningspeed("Main panning speed", Vector) = (0,0,0,0)
		[Toggle]_Invertmaintexture("Invert main texture", Range( 0 , 1)) = 0
		[HDR]_Maincolor("Main color", Color) = (0.7941176,0.1284602,0.1284602,0.666)
		[HDR]_Edgecolor("Edge color", Color) = (0.7941176,0.1284602,0.1284602,0.666)
		_Bias("Bias", Float) = 0
		_Scale("Scale", Float) = 1
		_Power("Power", Range( 0 , 5)) = 5
		_Secondarytexture("Secondary texture", 2D) = "black" {}
		_Seondarytextureintensity("Seondary texture intensity", Float) = 1
		_Secondarypanningspeed("Secondary panning speed", Vector) = (0,0,0,0)
		[Toggle]_Invertsecondarytexture("Invert secondary texture", Range( 0 , 1)) = 0
		[HDR]_Secondarycolor("Secondary color", Color) = (0,0,0,0)
		[Toggle]_Enabledistortion("Enable distortion", Range( 0 , 1)) = 0
		_Distortionscale("Distortion scale", Range( 0 , 10)) = 1
		_Distortionspeed("Distortion speed", Range( 0 , 5)) = 1
		_Extraroughness("Extra roughness", Range( 0 , 10)) = 0
		[Toggle]_Enablepulsation("Enable pulsation", Range( 0 , 1)) = 0
		_Pulsephase("Pulse phase", Float) = 0
		_Pulsefrequency("Pulse frequency", Float) = 3
		_Pulseamplitude("Pulse amplitude", Float) = 1
		_Pulseoffset("Pulse offset", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
		};

		uniform float _Enabledistortion;
		uniform float _Extraroughness;
		uniform float _Distortionspeed;
		uniform float _Distortionscale;
		uniform float _Enablepulsation;
		uniform float _Pulsefrequency;
		uniform float _Pulsephase;
		uniform float _Pulseamplitude;
		uniform float _Pulseoffset;
		uniform float _Globalopacity;
		uniform float _Bias;
		uniform float _Scale;
		uniform float _Power;
		uniform float4 _Edgecolor;
		uniform float _Seondarytextureintensity;
		uniform float _Invertsecondarytexture;
		uniform sampler2D _Secondarytexture;
		uniform float2 _Secondarypanningspeed;
		uniform float4 _Secondarytexture_ST;
		uniform float4 _Secondarycolor;
		uniform float _Maintextureintensity;
		uniform float _Invertmaintexture;
		uniform sampler2D _Maintexture;
		uniform float2 _Mainpanningspeed;
		uniform float4 _Maintexture_ST;
		uniform float4 _Maincolor;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float simplePerlin3D52 = snoise( ( ( _Extraroughness * ase_vertex3Pos ) + ase_vertexNormal + ( _Distortionspeed * _Time.y ) ) );
			float temp_output_76_0 = ( _Distortionscale / 100.0 );
			float3 VertexOut74 = ( ( _Enabledistortion * ( ase_vertexNormal * (( temp_output_76_0 * -1.0 ) + (simplePerlin3D52 - 0.0) * (temp_output_76_0 - ( temp_output_76_0 * -1.0 )) / (1.0 - 0.0)) ) ) + ( _Enablepulsation * ( ase_vertexNormal * (sin( (_Time.y*_Pulsefrequency + _Pulsephase) )*_Pulseamplitude + _Pulseoffset) ) ) );
			v.vertex.xyz += VertexOut74;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV1 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1 = ( _Bias + _Scale * pow( 1.0 - fresnelNdotV1, _Power ) );
			float4 FresnelOut66 = ( fresnelNode1 * _Edgecolor );
			float2 uv_Secondarytexture = i.uv_texcoord * _Secondarytexture_ST.xy + _Secondarytexture_ST.zw;
			float2 panner37 = ( _Time.y * _Secondarypanningspeed + uv_Secondarytexture);
			float4 tex2DNode32 = tex2D( _Secondarytexture, panner37 );
			float4 SecondaryTexOut72 = ( _Seondarytextureintensity * ( ( _Invertsecondarytexture * ( 1.0 - tex2DNode32 ) ) + ( ( 1.0 - _Invertsecondarytexture ) * tex2DNode32 ) ) * _Secondarycolor );
			float2 uv_Maintexture = i.uv_texcoord * _Maintexture_ST.xy + _Maintexture_ST.zw;
			float2 panner26 = ( _Time.y * _Mainpanningspeed + uv_Maintexture);
			float3 desaturateInitialColor56 = tex2D( _Maintexture, panner26 ).rgb;
			float desaturateDot56 = dot( desaturateInitialColor56, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar56 = lerp( desaturateInitialColor56, desaturateDot56.xxx, 1.0 );
			float4 MainTexOut64 = ( _Maintextureintensity * float4( ( ( _Invertmaintexture * ( 1.0 - desaturateVar56 ) ) + ( ( 1.0 - _Invertmaintexture ) * desaturateVar56 ) ) , 0.0 ) * _Maincolor );
			float4 EmissionOut70 = ( FresnelOut66 + SecondaryTexOut72 + MainTexOut64 );
			o.Emission = ( _Globalopacity * EmissionOut70 ).rgb;
			float FresnelMask68 = fresnelNode1;
			o.Alpha = ( _Globalopacity * FresnelMask68 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15800
512;73;984;491;2152.973;194.2065;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;77;-4002.266,-1303.958;Float;False;2077.09;620.5684;Main texture;16;22;56;25;58;57;61;59;60;62;24;64;40;26;29;28;30;Main texture;1,0.8264706,0.5661765,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;78;-4004.953,-457.0949;Float;False;2015.238;662.808;Secondary texture;15;93;63;39;72;38;89;92;91;90;88;32;37;35;34;36;Secondary texture;0.4411765,1,0.5837727,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;29;-3922.902,-814.3534;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-3949.108,-1080.589;Float;False;0;22;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;28;-3952.266,-950.1689;Float;False;Property;_Mainpanningspeed;Main panning speed;3;0;Create;True;0;0;False;0;0,0;0,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;35;-3824.862,44.31806;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;34;-3926.654,-82.25098;Float;False;Property;_Secondarypanningspeed;Secondary panning speed;12;0;Create;True;0;0;False;0;0,0;0,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;26;-3709.486,-969.9785;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-3919.177,-201.9295;Float;False;0;32;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;37;-3585.994,-121.3167;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;22;-3474.303,-966.0268;Float;True;Property;_Maintexture;Main texture;1;0;Create;True;0;0;False;0;None;5a225669b449f104ebfe1ac897d85446;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;80;-1781.556,-1521.595;Float;False;2186.53;1179.224;Vertex manipulation;8;74;119;128;129;127;126;124;125;Vertex manipulation;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-3192.294,-1216.078;Float;False;Property;_Invertmaintexture;Invert main texture;4;1;[Toggle];Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-3304.038,-370.6899;Float;False;Property;_Invertsecondarytexture;Invert secondary texture;13;1;[Toggle];Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;56;-3183.587,-964.0641;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;32;-3338.07,-147.186;Float;True;Property;_Secondarytexture;Secondary texture;10;0;Create;True;0;0;False;0;None;e3933cb2e2577fb4ab81423186807589;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;125;-1747.549,-1402.168;Float;False;1259.065;659.0585;Distortion;15;122;54;123;52;55;50;76;53;84;45;49;47;87;86;48;;1,0.3975925,0,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;88;-3028.013,-200.3608;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;25;-2916.086,-1042.074;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;89;-3027.548,-275.9608;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;79;-1768.508,-139.9559;Float;False;1057.146;569.5391;Fresnel;8;1;68;19;20;21;2;3;66;Fresnel;0.4632353,0.7334687,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;58;-2915.621,-1117.674;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;47;-1703.966,-884.0807;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-1730.805,-1349.593;Float;False;Property;_Extraroughness;Extra roughness;18;0;Create;True;0;0;False;0;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;124;-1736.584,-704.8448;Float;False;1437.686;328.0779;Pulsation;8;99;104;105;108;107;111;112;113;;0.990566,0.9615986,0.2663314,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-1727.108,-965.9724;Float;False;Property;_Distortionspeed;Distortion speed;17;0;Create;True;0;0;False;0;1;0.88;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;87;-1732.941,-1266.987;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-1646.87,-89.95594;Float;False;Property;_Bias;Bias;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-2801.531,-212.9289;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2692.204,-1156.042;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1654.496,-1.526977;Float;False;Property;_Scale;Scale;8;0;Create;True;0;0;False;0;1;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1718.508,103.0128;Float;False;Property;_Power;Power;9;0;Create;True;0;0;False;0;5;1.22;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-2804.131,-314.3289;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-2689.604,-1054.642;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-1704.318,-531.3018;Float;False;Property;_Pulsephase;Pulse phase;20;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-1704.622,-613.8749;Float;False;Property;_Pulsefrequency;Pulse frequency;21;0;Create;True;0;0;False;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;45;-1731.777,-1118.339;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-1477.599,-844.7416;Float;False;Property;_Distortionscale;Distortion scale;16;0;Create;True;0;0;False;0;1;0.01;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1437.476,-955.5549;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-1395.688,-1169.037;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;39;-2813.03,-106.8315;Float;False;Property;_Secondarycolor;Secondary color;14;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.2647059,0.6957404,1,0.978;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;63;-2824.566,-396.5133;Float;False;Property;_Seondarytextureintensity;Seondary texture intensity;11;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-2543.155,-1115.176;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;2;-1704.665,196.215;Float;False;Property;_Edgecolor;Edge color;6;1;[HDR];Create;True;0;0;False;0;0.7941176,0.1284602,0.1284602,0.666;0,0.7098039,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;62;-2906.697,-890.3909;Float;False;Property;_Maincolor;Main color;5;1;[HDR];Create;True;0;0;False;0;0.7941176,0.1284602,0.1284602,0.666;0,0.7098039,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-1236.88,-1104.373;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;1;-1452.036,-83.54285;Float;True;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;76;-1181.952,-840.5203;Float;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-2655.082,-273.4628;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;105;-1446.185,-628.6837;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2700.526,-1253.959;Float;False;Property;_Maintextureintensity;Main texture intensity;2;0;Create;True;0;0;False;0;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-2376.921,-1143.139;Float;True;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2496.907,-279.2797;Float;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1073.201,-1031.325;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;52;-1111.959,-1109.225;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-1072.326,-481.3312;Float;False;Property;_Pulseoffset;Pulse offset;23;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-1084.899,-566.3957;Float;False;Property;_Pulseamplitude;Pulse amplitude;22;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-1158.986,176.5831;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SinOpNode;104;-1249.935,-627.1249;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-2283.628,-284.6128;Float;False;SecondaryTexOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-954.3618,170.0819;Float;False;FresnelOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;123;-909.5964,-1248.979;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;111;-843.1877,-629.8052;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-2168.176,-1147.032;Float;False;MainTexOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;54;-906.7539,-1105.154;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;397.9737,2.174088;Float;False;66;FresnelOut;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-511.0839,-651.7536;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-438.4216,-1221.888;Float;False;Property;_Enabledistortion;Enable distortion;15;1;[Toggle];Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;310.3707,98.1729;Float;False;72;SecondaryTexOut;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;356.7406,202.4102;Float;False;64;MainTexOut;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-713.0171,-1154.255;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-464.5193,-806.3271;Float;False;Property;_Enablepulsation;Enable pulsation;19;1;[Toggle];Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-123.0278,-669.3439;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-135.1839,-1178.314;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;590.3882,46.07478;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;119;51.07063,-952.9338;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-1183.835,-87.57789;Float;False;FresnelMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;790.357,42.92546;Float;False;EmissionOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-430.4883,187.9967;Float;False;68;FresnelMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-428.8112,72.29493;Float;False;70;EmissionOut;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;177.059,-957.8647;Float;False;VertexOut;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-497.8174,-9.895609;Float;False;Property;_Globalopacity;Global opacity;0;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-196.9445,172.1026;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;-410.4673,303.6875;Float;False;74;VertexOut;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-175.341,-4.787806;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;17.16183,-68.13921;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;AdultLink/HoloShield;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;30;0
WireConnection;26;2;28;0
WireConnection;26;1;29;0
WireConnection;37;0;36;0
WireConnection;37;2;34;0
WireConnection;37;1;35;0
WireConnection;22;1;26;0
WireConnection;56;0;22;0
WireConnection;32;1;37;0
WireConnection;88;0;32;0
WireConnection;25;0;56;0
WireConnection;89;0;93;0
WireConnection;58;0;57;0
WireConnection;91;0;89;0
WireConnection;91;1;32;0
WireConnection;59;0;57;0
WireConnection;59;1;25;0
WireConnection;90;0;93;0
WireConnection;90;1;88;0
WireConnection;61;0;58;0
WireConnection;61;1;56;0
WireConnection;49;0;48;0
WireConnection;49;1;47;0
WireConnection;84;0;86;0
WireConnection;84;1;87;0
WireConnection;60;0;59;0
WireConnection;60;1;61;0
WireConnection;50;0;84;0
WireConnection;50;1;45;0
WireConnection;50;2;49;0
WireConnection;1;1;21;0
WireConnection;1;2;20;0
WireConnection;1;3;19;0
WireConnection;76;0;53;0
WireConnection;92;0;90;0
WireConnection;92;1;91;0
WireConnection;105;0;47;0
WireConnection;105;1;107;0
WireConnection;105;2;108;0
WireConnection;24;0;40;0
WireConnection;24;1;60;0
WireConnection;24;2;62;0
WireConnection;38;0;63;0
WireConnection;38;1;92;0
WireConnection;38;2;39;0
WireConnection;55;0;76;0
WireConnection;52;0;50;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;104;0;105;0
WireConnection;72;0;38;0
WireConnection;66;0;3;0
WireConnection;111;0;104;0
WireConnection;111;1;112;0
WireConnection;111;2;113;0
WireConnection;64;0;24;0
WireConnection;54;0;52;0
WireConnection;54;3;55;0
WireConnection;54;4;76;0
WireConnection;99;0;45;0
WireConnection;99;1;111;0
WireConnection;122;0;123;0
WireConnection;122;1;54;0
WireConnection;129;0;128;0
WireConnection;129;1;99;0
WireConnection;127;0;126;0
WireConnection;127;1;122;0
WireConnection;31;0;67;0
WireConnection;31;1;73;0
WireConnection;31;2;65;0
WireConnection;119;0;127;0
WireConnection;119;1;129;0
WireConnection;68;0;1;0
WireConnection;70;0;31;0
WireConnection;74;0;119;0
WireConnection;44;0;41;0
WireConnection;44;1;69;0
WireConnection;42;0;41;0
WireConnection;42;1;71;0
WireConnection;0;2;42;0
WireConnection;0;9;44;0
WireConnection;0;11;75;0
ASEEND*/
//CHKSM=937187851E30B19AA00866C31CC7066A62AE519D