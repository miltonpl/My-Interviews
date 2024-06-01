# DoorDash TPS: Building a checkout page

### Background
 
This small coding challenge will test your ability to code a simple, API driven UI from a design spec. More specifically, your task is to:

1. Consume the data in the `CheckoutService` by deserializing into a native type(s), and
2. Use your type(s) to populate a UI as spec'ed in `checkout.png`.
3. When the submit button is tapped, submit the order with the `CheckoutService` and transition to the order status page
as spec'ed in the `checkout.png`.

### Where to start
Currently, there exists a `CheckoutService`, which exposes a `fetchOrder` function for retrieving data from the mock network session and a `submitOrder` function to submit the order with the mock network session.  These functions can be updated as needed as you work on the project. The `FakeNetworkSession` should not be edited.

The button on the bottom of the screen is provided for you and you can add the appropriate action to submit the order and transition to the status page.

### Some files you should know about

`checkout.png` `checkout_recording.mov` - Design-provided UI specs for the checkout screen. This will show you what you need to build.
`CheckoutService.swift` - provides a function for retrieving data from a mock API and a function to submit the order.
`OrderResponse.json` - Provides the mocked API response for the order.
`SubmissionResponse.json` - Provides the mocked API response for the submission of the order.


### Some quick pointers:

1. You have limited time (about 45 minutes) so move quickly!
2. Your code does not need to be perfect, but you should still try to build in a clean & maintainable fashion. If you want to make a tradeoff for speed, mention it & explain why you're doing so.
3. If you are unclear about requirements, clarify! Your interviewer is there to help.


### API Schema Details

#### CheckoutService.fetchOrder response data

id: String (non-nil)
items.name: String (non-nil)
items.display_price: String (nullable) - the item's displayable price. If null, show "Free" as the price.

#### CheckoutService.submitOrder response data

status: String (non-nil) - either "preparing_order", "delivery_in_progress", or "delivered".

### Technology

The project is already set up to work with UIKit, if you're more comfortable working with SwiftUI that can also be used.

* Please use native APIs for layouts. You may use SwiftUI, or UIKit APIs such as NSLayoutConstraints, Interface Builder, and VFL.
