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


