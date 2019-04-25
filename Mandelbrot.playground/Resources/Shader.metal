#include <metal_stdlib>

using namespace metal;

inline float2 addC(float2 lhs, float2 rhs);
inline float2 multiplyC(float2 lhs, float2 rhs);
inline float absC(float2 lhs);


typedef struct {
    packed_float2 position;
    packed_float2 texCoords;
} VertexIn;

typedef struct {
    float4 position [[ position ]];
    float2 texCoords [[ user(texturecoord) ]];
} FragmentVertex;

vertex FragmentVertex simple_vertex(device VertexIn *vertexArray [[ buffer(0) ]],
                                      uint vertexIndex [[ vertex_id ]])
{
    VertexIn in = vertexArray[vertexIndex];

    FragmentVertex out;
    out.position = float4(in.position, 0.f, 1.f);
    out.texCoords = in.texCoords;

    return out;
}

fragment float4 simple_fragment(FragmentVertex in [[ stage_in ]],
                                texture2d<uint, access::sample> inputTexture [[ texture(0) ]],
                               sampler linearSampler [[ sampler(0) ]])
{
    float3 color = float3(inputTexture.sample(linearSampler, in.texCoords).x / 512.0);
    return float4(float3(0.5), 1.0);
}

kernel void doNothingComputeShader(texture2d<uint, access::write> outputTexture [[ texture(0) ]],
                                   const device uchar *pixelValues [[ buffer(0) ]],
                                   uint threadIdentifier [[ thread_position_in_grid ]])
{
    uint imageSizeInPixelsWidth = 512;
    int maximumIterations = 4096;
    int degree = 2;
    float threshold = 2;
    
    float2 tl = float2(-2.1, 1.5);
    float2 br = float2(1.0, -1.5);
    
    uint x = threadIdentifier % imageSizeInPixelsWidth;
    uint y = threadIdentifier / imageSizeInPixelsWidth;
    float xStep = imageSizeInPixelsWidth / (tl.x - br.x);
    float yStep = imageSizeInPixelsWidth / (tl.y - br.y);
    
//    float2 z, c = float2(x * xStep, y * yStep);
//    
//    int iterations = 0;
//    for (int i = 1; i < maximumIterations; i++) {
//        float2 zDegree = z;
//        for (int j = 0; j < degree - 1; j++) {
//            zDegree = multiplyC(z, zDegree);
//        }
//        z = addC(zDegree, c);
//        if (absC(z) > threshold) {
//            iterations = i;
//            break;
//        }
//    }

    outputTexture.write(x, uint2(x, y));
}

inline float2 multiplyC(float2 lhs, float2 rhs)
{
    return { lhs.x * rhs.x - lhs.y * rhs.y, lhs.x * rhs.y + rhs.x * lhs.y };
}
inline float2 addC(float2 lhs, float2 rhs)
{
    return { lhs.x + rhs.x, lhs.y + rhs.y };
}
inline float absC(float2 lhs)
{
    return sqrt(lhs.x * lhs.x + lhs.y * lhs.y);
}
