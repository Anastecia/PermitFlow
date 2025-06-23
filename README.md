# PermitFlow

PermitFlow is a decentralized application on the Stacks blockchain for managing and tracking construction permits. It aims to create a transparent and immutable record of the permit lifecycle for civil engineering projects.

## Features

-   **Apply for Permits**: Builders can submit applications for new construction projects.
-   **Authorize Permits**: A designated contract owner (representing a municipality) can approve pending permits.
-   **Verifiable Status**: Anyone can publicly query the status of a permit by its ID.
-   **Immutable History**: All permit actions are recorded on the blockchain.

## How to Use

The core logic is contained in the `permitflow.clar` smart contract.

-   `apply-for-permit`: Creates a new permit application.
-   `approve-permit`: Approves an existing application (owner only).
-   `get-permit-details`: Fetches the data for a specific permit.