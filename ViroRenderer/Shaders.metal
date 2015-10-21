//
//  Shaders.metal
//  ViroRenderer
//
//  Created by Raj Advani on 10/13/15.
//  Copyright © 2015 Raj Advani. All rights reserved.
//

#include <metal_stdlib>
#include <simd/simd.h>
#include "SharedStructures.h"

using namespace metal;

// Variables in constant address space
constant float3 light_position = float3(0.0, 1.0, -1.0);
constant float4 ambient_color  = float4(0.18, 0.24, 0.8, 1.0);

constexpr sampler s(coord::normalized,
                    address::repeat,
                    filter::linear);

typedef struct
{
    float3 position [[attribute(0)]];
    float2 uv [[attribute(1)]];
    float3 normal [[attribute(2)]];
} vertex_t;

typedef struct {
    float4 position [[position]];
    float4  color;
    float2 uv;
} ColorInOut;

// Vertex shader function
vertex ColorInOut lighting_vertex(vertex_t vertex_array [[stage_in]],
                                  constant uniforms_t& uniforms [[ buffer(1) ]])
{
    ColorInOut out;
    
    float4 in_position = float4(vertex_array.position, 1.0);
    out.position = uniforms.modelview_projection_matrix * in_position;
    out.uv = vertex_array.uv;
    
    float4 eye_normal = normalize(uniforms.normal_matrix * float4(vertex_array.normal, 0.0));
    float n_dot_l = dot(eye_normal.rgb, normalize(light_position));
    n_dot_l = fmax(0.0, n_dot_l);
    
    out.color = uniforms.diffuse_color;
    return out;
}

// Fragment shader function
fragment float4 lighting_fragment(ColorInOut in [[stage_in]],
                                 texture2d<float> diffuse_texture [[ texture(0)]])
{
    return in.color * diffuse_texture.sample(s, in.uv);
}
