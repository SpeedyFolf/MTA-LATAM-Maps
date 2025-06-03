float gTime : TIME;
texture Tex;

float3x3 getTransforMation ()
{
    float posU = -fmod( gTime/2 ,2 );    // Scroll Right
    float posV = 0;

    return float3x3(
                    1, 0, 0,
                    0, 1, 0,
                    posU, posV, 1
                    );
}

technique tec0
{
    pass P0
    {
		Texture[0] = Tex;

        TextureTransform[0] = getTransforMation();

        TextureTransformFlags[0] = Count2;
    }
}
