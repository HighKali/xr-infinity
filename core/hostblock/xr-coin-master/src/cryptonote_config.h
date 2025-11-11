#pragma once

#include <stdexcept>
#include <string>
#include <boost/uuid/uuid.hpp>

#define XR∞_NAME                                 "xr∞coin"
#define XR∞_DISPLAY_DECIMAL_POINT                12
#define XR∞_COIN                                  ((uint64_t)1000000000000) // 1 xr∞ = 10^12 atomic units
#define XR∞_DEFAULT_FEE                           ((uint64_t)10000000000)   // 10^10 atomic units
#define XR∞_FEE_PER_KB                            ((uint64_t)1000000000)    // 10^9 atomic units
#define XR∞_DUST_THRESHOLD                        ((uint64_t)2000000000)    // 2 * 10^9 atomic units

#define XR∞_GENESIS_NONCE                         88888
#define XR∞_GENESIS_TX                            "013c01ff0001ffffffffffff0302xr∞genesis0000000000000000000000000000000000000000000000000000000000000000"

#define XR∞_P2P_DEFAULT_PORT                      31337
#define XR∞_RPC_DEFAULT_PORT                      31338
#define XR∞_ZMQ_RPC_DEFAULT_PORT                  31339

#define XR∞_NETWORK_ID                            { { 0x88, 0x88, 0xF8, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88 } }

#define XR∞_PUBLIC_ADDRESS_BASE58_PREFIX          0x8888   // starts with "∞m"
#define XR∞_PUBLIC_INTEGRATED_ADDRESS_PREFIX       0x8889   // starts with "∞z"
#define XR∞_PUBLIC_SUBADDRESS_PREFIX               0x8890   // starts with "∞n"

#define XR∞_BLOCK_FUTURE_TIME_LIMIT                60*60*2
#define XR∞_MINED_MONEY_UNLOCK_WINDOW              60
#define XR∞_DEFAULT_TX_SPENDABLE_AGE               10

#define XR∞_DIFFICULTY_TARGET                      120
#define XR∞_DIFFICULTY_WINDOW                      720
#define XR∞_DIFFICULTY_LAG                         15
#define XR∞_DIFFICULTY_CUT                         60
#define XR∞_DIFFICULTY_BLOCKS_COUNT                (XR∞_DIFFICULTY_WINDOW + XR∞_DIFFICULTY_LAG)

#define XR∞_REWARD_BLOCKS_WINDOW                   100
#define XR∞_BLOCK_GRANTED_FULL_REWARD_ZONE         30000
#define XR∞_LONG_TERM_BLOCK_WEIGHT_WINDOW_SIZE     100000
#define XR∞_SHORT_TERM_BLOCK_WEIGHT_SURGE_FACTOR   20

#define XR∞_MEMPOOL_TX_LIVETIME                    (86400*3)
#define XR∞_MEMPOOL_TX_FROM_ALT_BLOCK_LIVETIME     604800

#define XR∞_COMMAND_RPC_GET_BLOCKS_FAST_MAX_COUNT  1000

#define XR∞_DEFAULT_RING_SIZE                       5
#define XR∞_BULLETPROOF_MAX_OUTPUTS                 16

#define XR∞_HASH_OF_HASHES_STEP                     256
#define XR∞_TXPOOL_MAX_WEIGHT                       648000000ull

#define XR∞_THREAD_STACK_SIZE                       5 * 1024 * 1024

#define XR∞_POOLDATA_FILENAME                       "xr∞_poolstate.bin"
#define XR∞_BLOCKCHAINDATA_FILENAME                 "xr∞_data.mdb"
#define XR∞_BLOCKCHAINDATA_LOCK_FILENAME            "xr∞_lock.mdb"
#define XR∞_P2P_NET_DATA_FILENAME                   "xr∞_p2pstate.bin"
#define XR∞_MINER_CONFIG_FILE_NAME                  "xr∞_miner_conf.json"
