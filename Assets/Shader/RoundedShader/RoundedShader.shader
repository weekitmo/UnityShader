Shader "Custom/RoundedShader"
{
    Properties
    {
        [PerRendererData]
        _MainTex ("Texture", 2D) = "white" {}

        _Color ("Main Color", Color) = (1, 1, 1, 1)
        _Radius ("Radius", Range(0, 0.5)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        // 多个SubShader的排序，数字越小，优先级越高
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            fixed _Radius;
            fixed4 _Color;

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f 
            {
                float4 pos: SV_POSITION;
                float2 uv: TEXCOORD0;
                float2 adaptUV: TEXCOORD1;
            };
            // 顶点着色器
            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                // 调整uv范围从(0, 1) 到(-0.5, 0.5)，即图片uv原点从左下角到中心点
                o.adaptUV = o.uv - fixed2(0.5, 0.5);
                return o;
            }
            // 片段着色器
            fixed4 frag(v2f input): SV_TARGET
            {
                fixed4 col = fixed4(0, 0, 0, 0);
                float innerLen = 0.5 - _Radius;
                float2 absAdaptUV = abs(input.adaptUV);
                // 首先绘制中间部分
                if (absAdaptUV.x < innerLen || absAdaptUV.y < innerLen)
                {
                    // 根据uv获取像素颜色
                    col = tex2D(_MainTex, input.uv);
                }
                else
                {  
                    if (length(absAdaptUV - fixed2(innerLen, innerLen)) < _Radius){
                        col = tex2D(_MainTex, input.uv);
                    }
                    else
                    {
                        // 超出的部分忽略掉
                        discard;
                    }
                }

                // 混合颜色
                return col * _Color;
            }

            ENDCG
        }
    }
}
