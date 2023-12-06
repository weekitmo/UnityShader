Shader "Custom/WaveShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _A ("Amplitude", Float) = 1
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
            float _A;

            v2f vert (appdata v)
            {
                v2f o;
                // _Time.y是正常的场景时间，z是2倍的场景时间，w是3倍的场景时间
                v.vertex.y += _A * sin( _Time.y + v.vertex.x );
                o.vertex = UnityObjectToClipPos(v.vertex);
                // 将模型顶点的uv和Tiling、Offset两个变量进行运算, 这里等效于([VariableName]_ST) _MainTex_ST.xy就是Tiling的xy值 _MainTex_ST.zw就是Offset的xy值
                // v.uv * _MainTex_ST.xy + _MainTex_ST.zw
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                return col;
            }
            ENDCG
        }
    }
}
