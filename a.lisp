;导入 libio库
(require libio)

; 更改标准输出到文件
(foutput "res.txt")

; 定义变量
(var max 100000)

; 定义含有max个true元素的列表
(var ans (repeat true max))


; 筛选法求素数
(
    for ii (range 2 max)
    (
        (if (== (lget ans ii) true)
            (   
                (
                    for jj (range (* 2 ii) max ii) (
                        (lset ans jj false)
                    )
                )
            )
        )
    )
)

; 打印结果
(
    for ii (range 2 max)
    (
        (if (== (lget ans ii) true)
            (rawprint ii "%t")
        )
    )
)