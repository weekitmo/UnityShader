Shader "Custom/NormalSurfShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        // 法线贴图 默认值 凹凸贴图
        _NormalMap("NormalMap",2D) = "bump"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        float4 _Color;
        sampler2D _NormalMap;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // 漫反射 = 颜色
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * _Color.rgb;
            // 法线 利用法线贴图可减少模型面数，提高性能
            o.Normal = UnpackNormal(tex2D(_NormalMap , IN.uv_MainTex));

        }

        ENDCG
    }
    FallBack "Diffuse"
}
