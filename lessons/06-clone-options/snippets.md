# Code from the post (not transcripts), numbered for demo.sh's `snippet N`

## snippet 1
```bash
git clone https://github.com/FreeRTOS/FreeRTOS-Kernel.git   # HTTPS
git clone git@github.com:FreeRTOS/FreeRTOS-Kernel.git       # SSH
```

## snippet 2
```bash
git clone -b smp https://github.com/FreeRTOS/FreeRTOS-Kernel.git
```

## snippet 3
```bash
git clone https://github.com/FreeRTOS/FreeRTOS-Kernel.git kernel-v11
```

## snippet 4
```bash
git clone --depth 1 https://github.com/FreeRTOS/FreeRTOS-Kernel.git
```

## snippet 5
```bash
git fetch --deepen=50     # 50 more commits of history
git fetch --unshallow     # the rest of it
```

## snippet 6
```bash
git clone --filter=blob:none https://github.com/FreeRTOS/FreeRTOS-Kernel.git
```

## snippet 7
```bash
git submodule update --init --recursive
```
