--
-- Function "GET_CHILD_PAGES"
--
CREATE OR REPLACE EDITIONABLE FUNCTION "WKSP_THARUN"."GET_CHILD_PAGES" (p_parent_id IN NUMBER) 
RETURN JSON_ARRAY_T IS
    l_children JSON_ARRAY_T := JSON_ARRAY_T();
    l_child JSON_OBJECT_T;
    CURSOR c_child_pages IS
        SELECT p.page_id,
               p.page_name,
               p.page_title,
               p.page_group
        FROM apex_application_pages p
        WHERE p.application_id = 200
        AND p.page_id > p_parent_id
        AND p.page_group = (
            SELECT page_group 
            FROM apex_application_pages 
            WHERE application_id = 200 
            AND page_id = p_parent_id
        )
        ORDER BY p.page_id;
BEGIN
    FOR r_page IN c_child_pages LOOP
        l_child := JSON_OBJECT_T();
        l_child.put('name', r_page.page_name);
        l_child.put('pageId', r_page.page_id);
        l_child.put('title', r_page.page_title);
        l_child.put('group', r_page.page_group);
        
        -- Check for sub-pages
        DECLARE
            l_has_children NUMBER;
        BEGIN
            SELECT COUNT(*)
            INTO l_has_children
            FROM apex_application_pages
            WHERE application_id = 200
            AND page_id > r_page.page_id
            AND page_group = r_page.page_group;
            
            IF l_has_children > 0 THEN
                l_child.put('children', get_child_pages(r_page.page_id));
            END IF;
        END;
        
        l_children.append(l_child);
    END LOOP;
    
    RETURN l_children;
END;
/