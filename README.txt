【预下载的模型配置】
1、DeepSeek-R1：/app/model/deepseek-ai/DeepSeek-R1
2、DeepSeek-V3-0324：/app/model/deepseek-ai/DeepSeek-V3-0324
3、DeepSeek-V2-Lite-Chat：/app/model/deepseek-ai/DeepSeek-V2-Lite-Chat

【启动命令：本地】
1、DeepSeek-R1：python -m ktransformers.local_chat --model_path /app/model/deepseek-ai/DeepSeek-R1 --gguf_path /app/model/DeepSeek-R1-GGUF
2、DeepSeek-V3-0324：python -m ktransformers.local_chat --model_path /app/model/deepseek-ai/DeepSeek-V3-0324 --gguf_path /app/model/DeepSeek-V3-0324-GGUF
3、DeepSeek-V2-Lite-Chat：python -m ktransformers.local_chat --model_path /app/model/deepseek-ai/DeepSeek-V2-Lite-Chat --gguf_path /app/model/DeepSeek-V2-Lite-Chat-GGUF
（GGUF文件需要下载到对应的目录内）

【部分GGUF的地址：国内可访问】
1、DeepSeek-R1：https://hf-mirror.com/unsloth/DeepSeek-R1-GGUF
2、DeepSeek-V3-0324：https://hf-mirror.com/unsloth/DeepSeek-V3-0324-GGUF
3、DeepSeek-V2-Lite-Chat：https://hf-mirror.com/mradermacher/DeepSeek-V2-Lite-GGUF

【官方部署文档】
https://kvcache-ai.github.io/ktransformers/en/install.html
