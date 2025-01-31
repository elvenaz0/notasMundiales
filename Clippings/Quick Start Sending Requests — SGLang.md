---
title: "Quick Start: Sending Requests — SGLang"
source: "https://docs.sglang.ai/start/send_request.html"
author:
published:
created: 2025-01-23
description:
tags:
  - "clippings"
---
## Quick Start: Sending Requests#

This notebook provides a quick-start guide to use SGLang in chat completions after installation.

- For Vision Language Models, see [OpenAI APIs - Vision](https://docs.sglang.ai/backend/openai_api_vision.html).
- For Embedding Models, see [OpenAI APIs - Embedding](https://docs.sglang.ai/backend/openai_api_embeddings.html) and [Encode (embedding model)](https://docs.sglang.ai/backend/native_api.html#Encode-\(embedding-model\)).
- For Reward Models, see [Classify (reward model)](https://docs.sglang.ai/backend/native_api.html#Classify-\(reward-model\)).

## Launch A Server#

This code block is equivalent to executing

```bash
python -m sglang.launch_server --model-path meta-llama/Meta-Llama-3.1-8B-Instruct \
--port 30000 --host 0.0.0.0
```

in your terminal and wait for the server to be ready. Once the server is running, you can send test requests using curl or requests. The server implements the [OpenAI-compatible APIs](https://platform.openai.com/docs/api-reference/chat).

```
from sglang.utils import (
    execute_shell_command,
    wait_for_server,
    terminate_process,
    print_highlight,
)

server_process = execute_shell_command(
    """
python -m sglang.launch_server --model-path meta-llama/Meta-Llama-3.1-8B-Instruct \
--port 30000 --host 0.0.0.0
"""
)

wait_for_server("http://localhost:30000")
```

```
[2025-01-23 19:34:55] server_args=ServerArgs(model_path='meta-llama/Meta-Llama-3.1-8B-Instruct', tokenizer_path='meta-llama/Meta-Llama-3.1-8B-Instruct', tokenizer_mode='auto', load_format='auto', trust_remote_code=False, dtype='auto', kv_cache_dtype='auto', quantization_param_path=None, quantization=None, context_length=None, device='cuda', served_model_name='meta-llama/Meta-Llama-3.1-8B-Instruct', chat_template=None, is_embedding=False, revision=None, skip_tokenizer_init=False, host='0.0.0.0', port=30000, mem_fraction_static=0.88, max_running_requests=None, max_total_tokens=None, chunked_prefill_size=8192, max_prefill_tokens=16384, schedule_policy='lpm', schedule_conservativeness=1.0, cpu_offload_gb=0, prefill_only_one_req=False, tp_size=1, stream_interval=1, random_seed=809822282, constrained_json_whitespace_pattern=None, watchdog_timeout=300, download_dir=None, base_gpu_id=0, log_level='info', log_level_http=None, log_requests=False, show_time_cost=False, enable_metrics=False, decode_log_interval=40, api_key=None, file_storage_pth='sglang_storage', enable_cache_report=False, dp_size=1, load_balance_method='round_robin', ep_size=1, dist_init_addr=None, nnodes=1, node_rank=0, json_model_override_args='{}', lora_paths=None, max_loras_per_batch=8, attention_backend='flashinfer', sampling_backend='flashinfer', grammar_backend='outlines', speculative_draft_model_path=None, speculative_algorithm=None, speculative_num_steps=5, speculative_num_draft_tokens=64, speculative_eagle_topk=8, enable_double_sparsity=False, ds_channel_config_path=None, ds_heavy_channel_num=32, ds_heavy_token_num=256, ds_heavy_channel_type='qk', ds_sparse_decode_threshold=4096, disable_radix_cache=False, disable_jump_forward=False, disable_cuda_graph=False, disable_cuda_graph_padding=False, disable_outlines_disk_cache=False, disable_custom_all_reduce=False, disable_mla=False, disable_overlap_schedule=False, enable_mixed_chunk=False, enable_dp_attention=False, enable_ep_moe=False, enable_torch_compile=False, torch_compile_max_bs=32, cuda_graph_max_bs=160, cuda_graph_bs=None, torchao_config='', enable_nan_detection=False, enable_p2p_check=False, triton_attention_reduce_in_fp32=False, triton_attention_num_kv_splits=8, num_continuous_decode_steps=1, delete_ckpt_after_loading=False, enable_memory_saver=False, allow_auto_truncate=False, enable_custom_logit_processor=False)
[2025-01-23 19:35:14 TP0] Init torch distributed begin.
[2025-01-23 19:35:15 TP0] Load weight begin. avail mem=78.81 GB
[2025-01-23 19:35:16 TP0] Using model weights format ['*.safetensors']
Loading safetensors checkpoint shards:   0% Completed | 0/4 [00:00<?, ?it/s]
Loading safetensors checkpoint shards:  25% Completed | 1/4 [00:00<00:02,  1.08it/s]
Loading safetensors checkpoint shards:  50% Completed | 2/4 [00:01<00:01,  1.75it/s]
Loading safetensors checkpoint shards:  75% Completed | 3/4 [00:02<00:00,  1.43it/s]
Loading safetensors checkpoint shards: 100% Completed | 4/4 [00:03<00:00,  1.25it/s]
Loading safetensors checkpoint shards: 100% Completed | 4/4 [00:03<00:00,  1.31it/s]

[2025-01-23 19:35:20 TP0] Load weight end. type=LlamaForCausalLM, dtype=torch.bfloat16, avail mem=63.72 GB
[2025-01-23 19:35:20 TP0] KV Cache is allocated. K size: 27.13 GB, V size: 27.13 GB.
[2025-01-23 19:35:20 TP0] Memory pool end. avail mem=8.34 GB
[2025-01-23 19:35:20 TP0] Capture cuda graph begin. This can take up to several minutes.
100%|██████████| 23/23 [00:06<00:00,  3.51it/s]
[2025-01-23 19:35:27 TP0] Capture cuda graph end. Time elapsed: 6.57 s
[2025-01-23 19:35:27 TP0] max_total_num_tokens=444500, max_prefill_tokens=16384, max_running_requests=2049, context_len=131072
[2025-01-23 19:35:27] INFO:     Started server process [889167]
[2025-01-23 19:35:27] INFO:     Waiting for application startup.
[2025-01-23 19:35:27] INFO:     Application startup complete.
[2025-01-23 19:35:27] INFO:     Uvicorn running on http://0.0.0.0:30000 (Press CTRL+C to quit)
[2025-01-23 19:35:28] INFO:     127.0.0.1:47208 - "GET /v1/models HTTP/1.1" 200 OK
[2025-01-23 19:35:28] INFO:     127.0.0.1:47220 - "GET /get_model_info HTTP/1.1" 200 OK
[2025-01-23 19:35:28 TP0] Prefill batch. #new-seq: 1, #new-token: 7, #cached-token: 0, cache hit rate: 0.00%, token usage: 0.00, #running-req: 0, #queue-req: 0
[2025-01-23 19:35:33] INFO:     127.0.0.1:47228 - "POST /generate HTTP/1.1" 200 OK
[2025-01-23 19:35:33] The server is fired up and ready to roll!
```

**NOTE: Typically, the server runs in a separate terminal.  
In this notebook, we run the server and notebook code together, so their outputs are combined.  
To improve clarity, the server logs are displayed in the original black color, while the notebook outputs are highlighted in blue.**

## Using cURL#

```
import subprocess, json

curl_command = """
curl -s http://localhost:30000/v1/chat/completions \
  -d '{"model": "meta-llama/Meta-Llama-3.1-8B-Instruct", "messages": [{"role": "user", "content": "What is the capital of France?"}]}'
"""

response = json.loads(subprocess.check_output(curl_command, shell=True))
print_highlight(response)
```

```
[2025-01-23 19:35:33 TP0] Prefill batch. #new-seq: 1, #new-token: 41, #cached-token: 1, cache hit rate: 2.04%, token usage: 0.00, #running-req: 0, #queue-req: 0
[2025-01-23 19:35:33] INFO:     127.0.0.1:47232 - "POST /v1/chat/completions HTTP/1.1" 200 OK
```

**{'id': '7cbcb572d5014a659f195d630a62ada7', 'object': 'chat.completion', 'created': 1737660933, 'model': 'meta-llama/Meta-Llama-3.1-8B-Instruct', 'choices': \[{'index': 0, 'message': {'role': 'assistant', 'content': 'The capital of France is Paris.', 'tool\_calls': None}, 'logprobs': None, 'finish\_reason': 'stop', 'matched\_stop': 128009}\], 'usage': {'prompt\_tokens': 42, 'total\_tokens': 50, 'completion\_tokens': 8, 'prompt\_tokens\_details': None}}**

## Using Python Requests#

```
import requests

url = "http://localhost:30000/v1/chat/completions"

data = {
    "model": "meta-llama/Meta-Llama-3.1-8B-Instruct",
    "messages": [{"role": "user", "content": "What is the capital of France?"}],
}

response = requests.post(url, json=data)
print_highlight(response.json())
```

```
[2025-01-23 19:35:33 TP0] Prefill batch. #new-seq: 1, #new-token: 1, #cached-token: 41, cache hit rate: 46.15%, token usage: 0.00, #running-req: 0, #queue-req: 0
[2025-01-23 19:35:33] INFO:     127.0.0.1:47234 - "POST /v1/chat/completions HTTP/1.1" 200 OK
```

**{'id': '9cebb37c23324617be149cb9ca1e9685', 'object': 'chat.completion', 'created': 1737660933, 'model': 'meta-llama/Meta-Llama-3.1-8B-Instruct', 'choices': \[{'index': 0, 'message': {'role': 'assistant', 'content': 'The capital of France is Paris.', 'tool\_calls': None}, 'logprobs': None, 'finish\_reason': 'stop', 'matched\_stop': 128009}\], 'usage': {'prompt\_tokens': 42, 'total\_tokens': 50, 'completion\_tokens': 8, 'prompt\_tokens\_details': None}}**

## Using OpenAI Python Client#

```
import openai

client = openai.Client(base_url="http://127.0.0.1:30000/v1", api_key="None")

response = client.chat.completions.create(
    model="meta-llama/Meta-Llama-3.1-8B-Instruct",
    messages=[
        {"role": "user", "content": "List 3 countries and their capitals."},
    ],
    temperature=0,
    max_tokens=64,
)
print_highlight(response)
```

```
[2025-01-23 19:35:34 TP0] Prefill batch. #new-seq: 1, #new-token: 13, #cached-token: 30, cache hit rate: 53.73%, token usage: 0.00, #running-req: 0, #queue-req: 0
[2025-01-23 19:35:34 TP0] Decode batch. #running-req: 1, #token: 60, token usage: 0.00, gen throughput (token/s): 5.91, #queue-req: 0
[2025-01-23 19:35:34] INFO:     127.0.0.1:47242 - "POST /v1/chat/completions HTTP/1.1" 200 OK
```

**ChatCompletion(id='26172c0d83314a6488aab6d30e4b87b6', choices=\[Choice(finish\_reason='stop', index=0, logprobs=None, message=ChatCompletionMessage(content='Here are 3 countries and their capitals:\\n\\n1. Country: Japan\\n Capital: Tokyo\\n\\n2. Country: Australia\\n Capital: Canberra\\n\\n3. Country: Brazil\\n Capital: Brasília', refusal=None, role='assistant', audio=None, function\_call=None, tool\_calls=None), matched\_stop=128009)\], created=1737660934, model='meta-llama/Meta-Llama-3.1-8B-Instruct', object='chat.completion', service\_tier=None, system\_fingerprint=None, usage=CompletionUsage(completion\_tokens=43, prompt\_tokens=43, total\_tokens=86, completion\_tokens\_details=None, prompt\_tokens\_details=None))**

### Streaming#

```
import openai

client = openai.Client(base_url="http://127.0.0.1:30000/v1", api_key="None")

# Use stream=True for streaming responses
response = client.chat.completions.create(
    model="meta-llama/Meta-Llama-3.1-8B-Instruct",
    messages=[
        {"role": "user", "content": "List 3 countries and their capitals."},
    ],
    temperature=0,
    max_tokens=64,
    stream=True,
)

# Handle the streaming output
for chunk in response:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="", flush=True)
```

```
[2025-01-23 19:35:34] INFO:     127.0.0.1:47254 - "POST /v1/chat/completions HTTP/1.1" 200 OK
[2025-01-23 19:35:34 TP0] Prefill batch. #new-seq: 1, #new-token: 1, #cached-token: 42, cache hit rate: 64.41%, token usage: 0.00, #running-req: 0, #queue-req: 0
Here are 3 countries and their capitals:

1. Country:[2025-01-23 19:35:34 TP0] Decode batch. #running-req: 1, #token: 57, token usage: 0.00, gen throughput (token/s): 113.78, #queue-req: 0
 Japan
   Capital: Tokyo

2. Country: Australia
   Capital: Canberra

3. Country: Brazil
   Capital: Brasília
```

## Using Native Generation APIs#

You can also use the native `/generate` endpoint with requests, which provides more flexiblity. An API reference is available at [Sampling Parameters](https://docs.sglang.ai/references/sampling_params.html).

```
import requests

response = requests.post(
    "http://localhost:30000/generate",
    json={
        "text": "The capital of France is",
        "sampling_params": {
            "temperature": 0,
            "max_new_tokens": 32,
        },
    },
)

print_highlight(response.json())
```

```
[2025-01-23 19:35:35 TP0] Prefill batch. #new-seq: 1, #new-token: 3, #cached-token: 3, cache hit rate: 63.93%, token usage: 0.00, #running-req: 0, #queue-req: 0
[2025-01-23 19:35:35 TP0] Decode batch. #running-req: 1, #token: 17, token usage: 0.00, gen throughput (token/s): 144.03, #queue-req: 0
[2025-01-23 19:35:35] INFO:     127.0.0.1:47260 - "POST /generate HTTP/1.1" 200 OK
```

**{'text': ' a city of romance, art, fashion, and history. Paris is a must-visit destination for anyone who loves culture, architecture, and cuisine. From the', 'meta\_info': {'id': '31a94320146c4fb39345a04214c4c565', 'finish\_reason': {'type': 'length', 'length': 32}, 'prompt\_tokens': 6, 'completion\_tokens': 32, 'cached\_tokens': 3}}**

### Streaming#

```
import requests, json

response = requests.post(
    "http://localhost:30000/generate",
    json={
        "text": "The capital of France is",
        "sampling_params": {
            "temperature": 0,
            "max_new_tokens": 32,
        },
        "stream": True,
    },
    stream=True,
)

prev = 0
for chunk in response.iter_lines(decode_unicode=False):
    chunk = chunk.decode("utf-8")
    if chunk and chunk.startswith("data:"):
        if chunk == "data: [DONE]":
            break
        data = json.loads(chunk[5:].strip("\n"))
        output = data["text"]
        print(output[prev:], end="", flush=True)
        prev = len(output)
```

```
[2025-01-23 19:35:35] INFO:     127.0.0.1:47268 - "POST /generate HTTP/1.1" 200 OK
[2025-01-23 19:35:35 TP0] Prefill batch. #new-seq: 1, #new-token: 1, #cached-token: 5, cache hit rate: 64.55%, token usage: 0.00, #running-req: 0, #queue-req: 0
 a city of romance, art, fashion, and cuisine. Paris is a must-visit[2025-01-23 19:35:35 TP0] Decode batch. #running-req: 1, #token: 25, token usage: 0.00, gen throughput (token/s): 144.39, #queue-req: 0
 destination for anyone who loves history, architecture, and culture. From the
```

```
terminate_process(server_process)
```