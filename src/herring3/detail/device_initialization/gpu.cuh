#pragma once
#include <type_traits>
#include <cuda_runtime_api.h>
#include <herring3/constants.hpp>
#include <herring3/detail/gpu_introspection.hpp>
#include <herring3/detail/infer_kernel/gpu.cuh>
#include <herring3/detail/forest.hpp>
#include <herring3/specializations/device_initialization_macros.hpp>
#include <kayak/device_id.hpp>
#include <kayak/device_setter.hpp>
#include <kayak/device_type.hpp>
#include <kayak/gpu_support.hpp>
namespace herring {
namespace detail {
namespace device_initialization {

template<typename forest_t, kayak::device_type D>
std::enable_if_t<kayak::GPU_ENABLED && D==kayak::device_type::gpu, void> initialize_device(kayak::device_id<D> device) {
  auto device_context = kayak::device_setter(device);
  auto max_shared_mem_per_block = get_max_shared_mem_per_block(device);
  // TODO: Include all infer variants
  kayak::cuda_check(
    cudaFuncSetAttribute(
      infer_kernel<false, uint8_t{1}, forest_t>,
      cudaFuncAttributeMaxDynamicSharedMemorySize,
      max_shared_mem_per_block
    )
  );
}

HERRING_INITIALIZE_DEVICE(extern template, 0)
HERRING_INITIALIZE_DEVICE(extern template, 1)
HERRING_INITIALIZE_DEVICE(extern template, 2)
HERRING_INITIALIZE_DEVICE(extern template, 3)

}
}
}

