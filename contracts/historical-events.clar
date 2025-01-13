;; Historical Events Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-parameters (err u101))
(define-constant err-not-authorized (err u102))

;; Data Variables
(define-data-var event-counter uint u0)
(define-map historical-events uint {
    civilization-id: uint,
    title: (string-ascii 100),
    description: (string-utf8 1000),
    date: uint,
    impact: uint,
    creator: principal
})

;; Public Functions
(define-public (create-historical-event (civilization-id uint) (title (string-ascii 100)) (description (string-utf8 1000)) (date uint) (impact uint))
    (let
        (
            (event-id (+ (var-get event-counter) u1))
        )
        (asserts! (is-some (contract-call? .civilization-data get-civilization civilization-id)) err-invalid-parameters)
        (asserts! (and (>= impact u1) (<= impact u10)) err-invalid-parameters)
        (map-set historical-events event-id {
            civilization-id: civilization-id,
            title: title,
            description: description,
            date: date,
            impact: impact,
            creator: tx-sender
        })
        (var-set event-counter event-id)
        (ok event-id)
    )
)

(define-public (update-historical-event (event-id uint) (description (string-utf8 1000)) (impact uint))
    (let
        (
            (event (unwrap! (map-get? historical-events event-id) err-invalid-parameters))
        )
        (asserts! (is-eq tx-sender (get creator event)) err-not-authorized)
        (asserts! (and (>= impact u1) (<= impact u10)) err-invalid-parameters)
        (map-set historical-events event-id
            (merge event {
                description: description,
                impact: impact
            })
        )
        (ok true)
    )
)

;; Read-only Functions
(define-read-only (get-historical-event (event-id uint))
    (map-get? historical-events event-id)
)

(define-read-only (get-event-count)
    (var-get event-counter)
)

