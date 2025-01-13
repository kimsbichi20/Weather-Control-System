;; Civilization Data Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-parameters (err u101))
(define-constant err-not-authorized (err u102))

;; Data Variables
(define-data-var civilization-counter uint u0)
(define-map civilizations uint {
    name: (string-ascii 100),
    description: (string-utf8 1000),
    home-planet: (string-ascii 100),
    technology-level: uint,
    cultural-traits: (list 10 (string-ascii 50)),
    creator: principal
})

;; Public Functions
(define-public (create-civilization (name (string-ascii 100)) (description (string-utf8 1000)) (home-planet (string-ascii 100)) (technology-level uint) (cultural-traits (list 10 (string-ascii 50))))
    (let
        (
            (civilization-id (+ (var-get civilization-counter) u1))
        )
        (asserts! (and (>= technology-level u1) (<= technology-level u10)) err-invalid-parameters)
        (map-set civilizations civilization-id {
            name: name,
            description: description,
            home-planet: home-planet,
            technology-level: technology-level,
            cultural-traits: cultural-traits,
            creator: tx-sender
        })
        (var-set civilization-counter civilization-id)
        (ok civilization-id)
    )
)

(define-public (update-civilization (civilization-id uint) (description (string-utf8 1000)) (technology-level uint) (cultural-traits (list 10 (string-ascii 50))))
    (let
        (
            (civilization (unwrap! (map-get? civilizations civilization-id) err-invalid-parameters))
        )
        (asserts! (is-eq tx-sender (get creator civilization)) err-not-authorized)
        (asserts! (and (>= technology-level u1) (<= technology-level u10)) err-invalid-parameters)
        (map-set civilizations civilization-id
            (merge civilization {
                description: description,
                technology-level: technology-level,
                cultural-traits: cultural-traits
            })
        )
        (ok true)
    )
)

;; Read-only Functions
(define-read-only (get-civilization (civilization-id uint))
    (map-get? civilizations civilization-id)
)

(define-read-only (get-civilization-count)
    (var-get civilization-counter)
)

