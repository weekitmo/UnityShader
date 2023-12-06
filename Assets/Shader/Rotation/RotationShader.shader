Shader "Unlit/RotationShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float angle = _Time.y;
                float2 uv = (0, 0);
                // 调整原点位置
                i.uv -= float2(0.5,0.5);

                if (length(i.uv) > 0.5) {
                    // 不显示
                    return fixed4(1, 1, 1, 1) * _Color;
                }
                // 旋转公式，根据cosθ和uv得出旋转angle弧度后的uv
                uv.x = i.uv.x * cos(angle) + i.uv.y * sin(angle);
                uv.y = i.uv.y * cos(angle) - i.uv.x * sin(angle);

                uv += float2(0.5, 0.5);
                fixed4 col = tex2D(_MainTex, uv);
                
                return col;
            }
            ENDCG
        }
    }
}
