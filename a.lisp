
(var max 100000)
(var ans '())
(for ii (range 1 max) (lset ans ii true))
(
    for ii (range 2 max)
    (
        (if (= (lget ans ii) true)
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
(
    for ii (range 2 max)
    (
        (if (= (lget ans ii) true)
            (print ii)
        )
    )
)