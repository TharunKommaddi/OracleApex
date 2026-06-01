--
-- Package_Body "PCK_CUSTOMER_ORDER_GRID"
--
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_THARUN"."PCK_CUSTOMER_ORDER_GRID" AS
  -- Type definitions for our grid data
  TYPE t_customer_record IS RECORD (
    customerId NUMBER,
    name VARCHAR2(100),
    email VARCHAR2(100),
    country VARCHAR2(50),
    color_code VARCHAR2(30),
    order_count NUMBER,
    spaltenindex NUMBER
  );
  
  TYPE t_product_record IS RECORD (
    productId NUMBER,
    product_name VARCHAR2(100),
    category VARCHAR2(50),
    unit_price NUMBER,
    spaltenindex NUMBER
  );
  
  TYPE t_customer_table IS TABLE OF t_customer_record;
  TYPE t_product_table IS TABLE OF t_product_record;
  
  -- Package variables
  lCustomerList t_customer_table;
  lProductList t_product_table;
  gMaxColumnIndex NUMBER := 0;
  gMaxRowIndex NUMBER := 0;
  
  -- Selected IDs
  g_customer_ids VARCHAR2(4000);
  g_product_ids VARCHAR2(4000);
  g_highlight_months NUMBER;
  
  -- Main initialization procedure
  -- Update the pInit procedure to enhance the empty state UI
PROCEDURE pInit(
  aCustomerList IN VARCHAR2,
  aProductList IN VARCHAR2,
  aHighlightOrdersMonths IN NUMBER DEFAULT 0
) IS
BEGIN
  -- Store parameters for later use
  g_customer_ids := aCustomerList;
  g_product_ids := aProductList;
  g_highlight_months := aHighlightOrdersMonths;
  
  -- Initialize collections
  lCustomerList := t_customer_table();
  lProductList := t_product_table();
  
  -- Show enhanced message if no selections made
  IF (aCustomerList IS NULL OR aCustomerList = ':') OR (aProductList IS NULL OR aProductList = ':') THEN
    htp.p('<div class="gridcontainer" style="display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 40px; text-align: center; color: #555; height: 500px; background-color: #f9f9f9; border-radius: 6px; border: 1px solid #e0e0e0;">');
    
    -- Add an icon
    htp.p('<div style="font-size: 48px; color: #0066cc; margin-bottom: 20px;">');
    htp.p('<span class="fa fa-filter"></span>');
    htp.p('</div>');
    
    -- Add a heading
    htp.p('<h2 style="font-size: 24px; margin-bottom: 10px; color: #333;">Please select at least one customer and one product</h2>');
    
    -- Add a description
    htp.p('<p style="font-size: 16px; margin-bottom: 20px; max-width: 500px; line-height: 1.5;">');
    htp.p('Use the shuttle selectors above and click "Apply Filter" to view data.');
    htp.p('</p>');
    
    -- Add helpful instructions
    htp.p('<div style="background-color: #fff; border: 1px solid #e0e0e0; border-radius: 6px; padding: 20px; max-width: 600px; text-align: left;">');
    htp.p('<h3 style="font-size: 16px; margin-bottom: 12px; color: #333;">Quick Instructions:</h3>');
    htp.p('<ol style="padding-left: 20px; margin: 0;">');
    htp.p('<li style="margin-bottom: 8px;">Select customers from the left shuttle by clicking on names and using the arrow buttons</li>');
    htp.p('<li style="margin-bottom: 8px;">Select products from the right shuttle the same way</li>');
    htp.p('<li style="margin-bottom: 8px;">Click the red "Apply Filter" button to view the grid</li>');
    htp.p('<li style="margin-bottom: 0;">You can optionally set the "Highlight Orders" value to show recent orders</li>');
    htp.p('</ol>');
    htp.p('</div>');
    
    -- Add a visual arrow pointing up to the filter area
    htp.p('<div style="position: absolute; top: 120px; left: 50%; transform: translateX(-50%);">');
    htp.p('<span class="fa fa-arrow-up" style="font-size: 24px; color: #0066cc;"></span>');
    htp.p('</div>');
    
    htp.p('</div>');
    RETURN; -- Exit early
  END IF;
  
  -- Start the grid container
  htp.p('<div class="gridcontainer">');
EXCEPTION
  WHEN OTHERS THEN
    htp.p('<div class="t-Alert t-Alert--danger"><div class="t-Alert-wrap">');
    htp.p('<div class="t-Alert-icon"><span class="t-Icon fa fa-warning"></span></div>');
    htp.p('<div class="t-Alert-content"><div class="t-Alert-header">');
    htp.p('<h2 class="t-Alert-title">Error Loading Grid</h2></div>');
    htp.p('<div class="t-Alert-body">An error occurred: ' || SQLERRM || '</div>');
    htp.p('</div></div></div>');
END pInit;

  -- Draw the customer columns
  PROCEDURE pDrawCustomers IS
    lColumnIndex NUMBER := 3; -- Start from column 3 to leave space for product rows
    lOrderColumnWidth NUMBER := 180; -- Width in pixels for each order column
    lTotalCustomerWidth NUMBER; -- Total width for customer cells
  BEGIN
    -- If no selections, exit early
    IF g_customer_ids IS NULL OR g_customer_ids = ':' OR g_product_ids IS NULL OR g_product_ids = ':' THEN
      RETURN;
    END IF;
    
    -- Create the top-left corner cell with headers and sticky positioning
    htp.p('<div class="topleft" style="position:sticky; left:0; top:0; z-index:6;">');
    htp.p('<div class="topleft-content">');
    htp.p('<div class="category-header" style="width:130px; position:sticky; left:0;">CATEGORY</div>');
    htp.p('<div class="product-header" style="position:sticky; left:130px;">PRODUCT NAME</div>');
    htp.p('</div>');
    htp.p('</div>');
    
    -- Add CSS for grid template columns
    htp.p('<style type="text/css">.gridcontainer { grid-template-columns: 130px 180px repeat(auto-fill, ' || lOrderColumnWidth || 'px) !important; }</style>');
    
    -- Loop through each selected customer
    FOR c_rec IN (
      SELECT 
        c.customer_id, 
        c.name, 
        c.email, 
        c.country, 
        c.color_code,
        COUNT(o.order_id) as order_count
      FROM t_customers c
      LEFT JOIN t_orders o ON c.customer_id = o.customer_id
      WHERE c.customer_id IN (SELECT column_value FROM TABLE(apex_string.split_numbers(g_customer_ids, ':')))
      GROUP BY c.customer_id, c.name, c.email, c.country, c.color_code
      ORDER BY c.name
    ) LOOP
      -- Calculate total width for customer cell (3 order columns)
      lTotalCustomerWidth := lOrderColumnWidth * 3;
      
      -- Create a default email if missing
      IF c_rec.email IS NULL THEN
        c_rec.email := LOWER(REPLACE(c_rec.name, ' ', '.')) || '@email.com';
      END IF;
      
      -- Create a default country if missing
      IF c_rec.country IS NULL THEN
        c_rec.country := 'USA';
      END IF;
      
      -- Main customer header with name and info
      htp.p('<div class="customer" cid="' || c_rec.customer_id || '" cname="' || c_rec.name || 
            '" style="grid-column: ' || (lColumnIndex) || ' / span 3; min-width: ' || lTotalCustomerWidth || 
            'px; width: ' || lTotalCustomerWidth || 'px; max-width: ' || lTotalCustomerWidth || 
            'px; height: 120px; padding: 15px 12px; display: flex; flex-direction: column; justify-content: center; align-items: center; box-sizing: border-box;">');
      
      -- Customer details
      htp.p('<div class="customername" style="font-weight: 600; font-size: 14px; margin-bottom: 6px; padding: 0 5px; text-align: center;">' || c_rec.name || 
            '<div class="customercountry" style="font-size: 12px; color: #666; margin-top: 4px; margin-bottom: 4px; text-align: center;">' || c_rec.country || '</div></div>');
      
      -- Customer email
      htp.p('<div class="customeremail" style="font-size: 12px; color: #0066cc; margin: 6px 0; padding: 0 5px; text-align: center;">' || c_rec.email || '</div>');
      
      -- Count of orders
      htp.p('<div class="customerorders" style="font-size: 12px; background-color: #f5f5f5; padding: 5px 10px; border-radius: 12px; color: #555; margin-top: 6px; text-align: center;"><span class="fa fa-shopping-cart"></span> ' || 
            c_rec.order_count || ' Orders</div>');
      
      htp.p('</div>');
      
      -- Sub-headers for the different order status types
      htp.p('<div class="subheader" style="grid-column: ' || (lColumnIndex) || '; min-width: ' || lOrderColumnWidth || 
            'px; width: ' || lOrderColumnWidth || 'px; max-width: ' || lOrderColumnWidth || 
            'px; padding: 10px 15px; box-sizing: border-box;">RECENT ORDERS</div>');
            
      htp.p('<div class="subheader" style="grid-column: ' || (lColumnIndex+1) || '; min-width: ' || lOrderColumnWidth || 
            'px; width: ' || lOrderColumnWidth || 'px; max-width: ' || lOrderColumnWidth || 
            'px; padding: 10px 15px; box-sizing: border-box;">PROCESSING</div>');
            
      htp.p('<div class="subheader" style="grid-column: ' || (lColumnIndex+2) || '; min-width: ' || lOrderColumnWidth || 
            'px; width: ' || lOrderColumnWidth || 'px; max-width: ' || lOrderColumnWidth || 
            'px; padding: 10px 15px; box-sizing: border-box;">COMPLETED</div>');
      
      -- Create background styling with exact width
      htp.p('<div class="bgv" style="grid-column: ' || (lColumnIndex) || ' / span 3; min-width: ' || lTotalCustomerWidth || 
            'px; width: ' || lTotalCustomerWidth || 'px; max-width: ' || lTotalCustomerWidth || 'px;"></div>');
      
      -- Add the customer to our internal list with the column index
      lCustomerList.EXTEND;
      lCustomerList(lCustomerList.COUNT).customerId := c_rec.customer_id;
      lCustomerList(lCustomerList.COUNT).name := c_rec.name;
      lCustomerList(lCustomerList.COUNT).email := c_rec.email;
      lCustomerList(lCustomerList.COUNT).country := c_rec.country;
      lCustomerList(lCustomerList.COUNT).color_code := c_rec.color_code;
      lCustomerList(lCustomerList.COUNT).order_count := c_rec.order_count;
      lCustomerList(lCustomerList.COUNT).spaltenindex := lColumnIndex;
      
      lColumnIndex := lColumnIndex + 3;
    END LOOP;
    
    gMaxColumnIndex := lColumnIndex;
  END pDrawCustomers;
  
  -- Draw the product rows
  PROCEDURE pDrawProducts IS
    lRowIndex NUMBER := 1;
    lCurrentCategory VARCHAR2(100) := '';
  BEGIN
    -- If no selections, exit early
    IF g_customer_ids IS NULL OR g_customer_ids = ':' OR g_product_ids IS NULL OR g_product_ids = ':' THEN
      RETURN;
    END IF;
    
    -- Loop through each selected product
    FOR p_rec IN (
      SELECT 
        p.product_id, 
        p.product_name, 
        p.category, 
        p.unit_price
      FROM t_products p
      WHERE p.product_id IN (SELECT column_value FROM TABLE(apex_string.split_numbers(g_product_ids, ':')))
      ORDER BY p.category, p.product_name
    ) LOOP
      -- Check if this is a new category
      IF lCurrentCategory != p_rec.category THEN
        -- This is a new category - create a category header row
        lCurrentCategory := p_rec.category;
        
        -- Create the background for category row
        htp.p('<div class="bg category-bg" style="grid-row: ' || (lRowIndex+2) || 
              '; grid-column: 1 / span ' || gMaxColumnIndex || '"></div>');
        
        -- Create the category header with special styling and sticky positioning
        htp.p('<div pid="' || p_rec.product_id || '" pname="' || p_rec.product_name || 
              '" class="productcat pmenu category-header-cell" style="grid-row: ' || (lRowIndex+2) || 
              '; position: sticky; left: 0; z-index: 5; min-width: 130px; width: 130px;">' || 
              '<span>' || lCurrentCategory || '</span></div>');
        
        -- Empty cell for product name in category row to maintain grid structure
        htp.p('<div class="category-spacer" style="grid-row: ' || (lRowIndex+2) || 
              '; grid-column: 2 / span 1; background-color: #444; border-left: 1px solid #555;"></div>');
        
        -- Increment row index for the next product
        lRowIndex := lRowIndex + 1;
      END IF;
      
      -- Create the background for product row
      htp.p('<div class="bg" style="grid-row: ' || (lRowIndex+2) || 
            '; grid-column: 1 / span ' || gMaxColumnIndex || '"></div>');
            
      -- Create the category cell with sticky positioning and wider width
      htp.p('<div pid="' || p_rec.product_id || '" pname="' || p_rec.product_name || 
            '" class="productcat pmenu" style="grid-row: ' || (lRowIndex+2) || 
            '; position: sticky; left: 0; z-index: 4; min-width: 130px; width: 130px;">' || 
            '<span>' || p_rec.category || '</span></div>');
            
      -- Create the product name cell with sticky positioning and wider width
      htp.p('<div pid="' || p_rec.product_id || '" pname="' || p_rec.product_name || 
            '" class="productname pmenu" style="grid-row: ' || (lRowIndex+2) || 
            '; position: sticky; left: 130px; z-index: 3; min-width: 180px; width: 180px;">' || 
            p_rec.product_name || ' <span class="price">$' || 
            TO_CHAR(p_rec.unit_price, 'FM999,990.00') || '</span></div>');
      
      -- Add the product to our internal list with the row index
      lProductList.EXTEND;
      lProductList(lProductList.COUNT).productId := p_rec.product_id;
      lProductList(lProductList.COUNT).product_name := p_rec.product_name;
      lProductList(lProductList.COUNT).category := p_rec.category;
      lProductList(lProductList.COUNT).unit_price := p_rec.unit_price;
      lProductList(lProductList.COUNT).spaltenindex := lRowIndex;
      
      lRowIndex := lRowIndex + 1;
    END LOOP;
    
    gMaxRowIndex := lRowIndex + 2;
    
    -- Add styling for the full height of the grid
    htp.p('<style type="text/css"> .bgv { grid-row: 1 / span ' || gMaxRowIndex || '}</style>');
  END pDrawProducts;
  
  -- Draw the order cells in the grid
  PROCEDURE pDrawOrders IS
  BEGIN
    -- If no selections, exit early
    IF g_customer_ids IS NULL OR g_customer_ids = ':' OR g_product_ids IS NULL OR g_product_ids = ':' THEN
      RETURN;
    END IF;
    
    -- Loop through orders and place them in the grid
    FOR lOrder IN (
      SELECT o.order_id, 
             o.customer_id, 
             oi.product_id,
             o.order_date,
             o.order_status,
             o.order_total,
             oi.quantity,
             o.tracking_number,
             oi.line_total
      FROM t_orders o
      JOIN t_order_items oi ON o.order_id = oi.order_id
      WHERE o.customer_id IN (SELECT column_value FROM TABLE(apex_string.split_numbers(g_customer_ids, ':')))
      AND oi.product_id IN (SELECT column_value FROM TABLE(apex_string.split_numbers(g_product_ids, ':')))
      ORDER BY o.order_date DESC
    ) LOOP
      -- Find the customer's column index
      DECLARE
        lCustomerIndex NUMBER := 0;
        lProductIndex NUMBER := 0;
        lStatusClass VARCHAR2(20);
        lRecentClass VARCHAR2(20);
        lOrderDate DATE;
      BEGIN
        -- Find customer index
        FOR i IN 1..lCustomerList.COUNT LOOP
          IF lCustomerList(i).customerId = lOrder.customer_id THEN
            lCustomerIndex := lCustomerList(i).spaltenindex;
            EXIT;
          END IF;
        END LOOP;
        
        -- Find product index
        FOR i IN 1..lProductList.COUNT LOOP
          IF lProductList(i).productId = lOrder.product_id THEN
            lProductIndex := lProductList(i).spaltenindex;
            EXIT;
          END IF;
        END LOOP;
        
        -- Skip if either customer or product index not found
        IF lCustomerIndex = 0 OR lProductIndex = 0 THEN
          CONTINUE;
        END IF;
        
        -- Determine which column based on status
        CASE lOrder.order_status
          WHEN 'New' THEN 
            lStatusClass := 'neworder';
            lCustomerIndex := lCustomerIndex;
          WHEN 'Processing' THEN 
            lStatusClass := 'processing';
            lCustomerIndex := lCustomerIndex + 1;
          WHEN 'Shipped' THEN 
            lStatusClass := 'completed';
            lCustomerIndex := lCustomerIndex + 2;
          WHEN 'Completed' THEN 
            lStatusClass := 'completed';
            lCustomerIndex := lCustomerIndex + 2;
          WHEN 'Cancelled' THEN 
            lStatusClass := 'cancelled';
            lCustomerIndex := lCustomerIndex + 2;
          ELSE
            lStatusClass := '';
            lCustomerIndex := lCustomerIndex;
        END CASE;
        
        -- Handle highlighting of recent orders
        lOrderDate := CAST(lOrder.order_date AS DATE);
        IF (g_highlight_months > 0 AND 
            lOrderDate > (SYSDATE - (30 * g_highlight_months))) THEN
          lRecentClass := ' highlight';
        ELSE
          lRecentClass := '';
        END IF;
        
        -- Draw the order cell with wider width
        htp.p('<div class="order ' || lStatusClass || lRecentClass || '" oid="' || lOrder.order_id || 
              '" cid="' || lOrder.customer_id || '" pid="' || lOrder.product_id || 
              '" style="grid-column: ' || lCustomerIndex || '; grid-row: ' || (lProductIndex+2) || 
              '; min-width: 150px; padding: 15px;">');

        -- Show order total and quantity
        htp.p('<span class="fa fa-info-square-o infobox"></span>');
        htp.p('<span class="orderqty">Qty: ' || lOrder.quantity || '</span>');
        htp.p('<span class="ordertotal">$' || TO_CHAR(lOrder.line_total, 'FM999,990.00') || '</span>');
        
        -- Add tracking number for shipped orders
        IF lOrder.tracking_number IS NOT NULL THEN
          htp.p('<span class="tracking" title="Tracking: ' || lOrder.tracking_number || '">' ||
                '<span class="fa fa-truck"></span></span>');
        END IF;
        
        htp.p('</div>');
      END;
    END LOOP;
    
    -- Close the grid container
    htp.p('</div>');
  END pDrawOrders;
  
END PCK_CUSTOMER_ORDER_GRID;
/