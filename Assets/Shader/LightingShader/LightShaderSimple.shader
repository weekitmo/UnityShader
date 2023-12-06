Shader "Custom/LightShaderSimple"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        // 需要再Window/Rendering/Lighting配置Environment Lighting为Color可测试
        Lighting On

        Material{
            // 漫反射
            Diffuse[_Color]
            // 环境光
            Ambient[_Color]
            // 其他 自发光(emissive)
        }

        Pass
        {
            SetTexture[_MainTex]{
                combine texture * previous
            }
        }
    }
}
