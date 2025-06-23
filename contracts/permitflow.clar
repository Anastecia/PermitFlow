;; PermitFlow: A contract for managing construction permits.
;; This contract allows an authorized party (the municipality) to issue
;; and track permits for construction projects.

;; --- Constants and Errors ---
(define-constant ERR-NOT-AUTHORIZED u101)
(define-constant ERR-PERMIT-NOT-FOUND u102)
(define-constant ERR-ALREADY-APPROVED u103)

(define-constant STATUS-PENDING u0)
(define-constant STATUS-APPROVED u1)
(define-constant STATUS-REJECTED u2)

;; --- Data Storage ---
(define-data-var contract-owner principal tx-sender)
(define-data-var permit-counter uint u0)

(define-map permits uint {
  applicant: principal,
  project-id: (string-ascii 64),
  status: uint
})

;; --- Public Functions ---

;; Apply for a new construction permit.
;; Anyone can call this to create a new permit in a 'pending' state.
(define-public (apply-for-permit (project-id (string-ascii 64)))
  (let ((new-permit-id (+ (var-get permit-counter) u1)))
    (map-set permits new-permit-id {
      applicant: tx-sender,
      project-id: project-id,
      status: STATUS-PENDING
    })
    (var-set permit-counter new-permit-id)
    (ok new-permit-id)
  )
)

;; Approve a pending permit.
;; Only the contract owner (municipality) can call this.
(define-public (approve-permit (permit-id uint))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) (err ERR-NOT-AUTHORIZED))
    (match (map-get? permits permit-id)
      permit-details
      (begin
        (asserts! (not (is-eq (get status permit-details) STATUS-APPROVED)) (err ERR-ALREADY-APPROVED))
        (map-set permits permit-id (merge permit-details { status: STATUS-APPROVED }))
        (ok true)
      )
      (err ERR-PERMIT-NOT-FOUND)
    )
  )
)

;; --- Read-Only Functions ---

;; Get the details of a specific permit.
(define-read-only (get-permit-details (permit-id uint))
  (map-get? permits permit-id)
)

;; Get the total number of permits issued.
(define-read-only (get-permit-count)
  (ok (var-get permit-counter))
)