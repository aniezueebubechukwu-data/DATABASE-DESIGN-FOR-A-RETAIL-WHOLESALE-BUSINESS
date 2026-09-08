# DATABASE-DESIGN-FOR-A-RETAIL-WHOLESALE-BUSINESS
The goal of this project is to foster efficient entry and retrieval of every record associated with the business 

### PURPOSE
Zentra Ltd is a company that’s into the sale of quality umbrellas and canopies. They currently track their sales, purchases, inventory informally (memory, Whatsapp chat, notebook). The goal of the system, **OLTP**(Online Transaction Processing) database is to record and query every transaction efficiently, whether it’s a sale, purchase, money owed or stock level etc

### STAKEHOLDERS
### Below outlines each stakeholders and their interest in the system 

BUSINESS OWNER (CEO) :- Full visibility into stock, purchase, sales, credit and profit without asking the staff

SHOP STAFF (2 EMPLOYEES) :- Easily enter a sale  and delivery record

CUSTOMER :- Not direct user. But their purchase and credit history must be tracked accurately

SUPPLIER :- Not a direct user. But what is owed to them must be entered accurately

### BUSINESS CONTEXT
### The information gathered below describes the business operation :

- Products are bought from multiple suppliers and split across two physical locations: a warehouse (bulky items like canopies) and a shop (smaller items, though some overlap exists between both).
  
- Customers are both retail (walk-in) and wholesale (bulk buyers), and payment can be cash, POS, transfer, or credit with a due date.
  
- The business itself sometimes buys from its own suppliers on credit.
  
- Two staff handle packaging and sales entry.
  
- Some customers are recurring, others are one-off.
  
- Some orders are dispatched to other states rather than collected in person.
  

### FUNCTIONAL REQUIREMENTS

Grouped by business domain each maps to one or more tables in the eventual schema.

**Inventory**

- The system must track stock quantity per product, per location independently.
- The system must prevent a sale from reducing stock below zero at a given location.
- The system must flag products at or below a defined reorder threshold.

**Purchasing**

- The system must record purchases from suppliers, including which location received the goods.
- The system must support purchases paid in full, in part, or entirely on credit, with a due date where applicable.

**Sales**

- The system must record sales as retail or wholesale, with pricing that can differ from the product's default.
- The system must support a sale to an unregistered/anonymous walk-in customer.
- The system must support multiple payment methods against a single sale, including partial payment.

**Customers & Credit**

- The system must distinguish recurring customers from new/one-off customers.
- The system must be able to report, at any time, how much any given customer currently owes.

**Staff Accountability**

- Every sale must record which staff member entered it.
- Every purchase must record which staff member received the delivery.

**Dispatch**

- The system must track orders delivered to other states, including courier and delivery status, separately from orders collected in person.

**Reporting (the CEO layer)**

- The system must be able to summarize, for any given day: total sales by type, payments by method, outstanding customer credit, outstanding supplier credit, and estimated profit.

### BUSINESS RULES

Constraints and logic derived directly from how the business actually works, which the schema must enforce or support:

- A product's stock is meaningful only in the context of a specific location "how many do we have" is never a single number without also asking "where."
- A sale can draw stock from the business's own inventory.
- A customer or supplier balance is not a stored value it is always the difference between what was agreed (total amount) and what has actually been paid (amount paid) as of now.
- A sale is not necessarily fully paid at the time it's recorded partial payment and later settlement must also be accounted for.
- Not every sale is dispatched; dispatch is the exception, not the default flow

### PRELIMINARY ENTITY LIST

Before formal ER modeling, the nouns and events identified from the business narrative are seen below:

**Core entities (things):** Product, Location, Supplier, Customer, Employee

**Transactional events (things that happen):** Purchase, Sale, Payment, Dispatch

**Associative/detail records (connect entities to events):** Purchase line item, Sale line item, Inventory record (product × location)

Entity relationship diagram for the retail-wholesale business, showing suppliers, purchases, products, inventory, locations, customers, sales, payments, employees, and dispatch tables

[RETAIL-WHOLESALE BUSINESS ER-DIAGRAM](https://drive.google.com/file/d/1sUylEDfsWjDMMYVlEqNzWyjhzDMUKqrD/view?usp=drive_link)

