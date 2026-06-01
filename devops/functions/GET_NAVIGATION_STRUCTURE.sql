--
-- Function "GET_NAVIGATION_STRUCTURE"
--
CREATE OR REPLACE EDITIONABLE FUNCTION "WKSP_THARUN"."GET_NAVIGATION_STRUCTURE" 
RETURN CLOB IS
    l_json JSON_OBJECT_T := JSON_OBJECT_T();
    l_children JSON_ARRAY_T := JSON_ARRAY_T();
    l_result CLOB;
BEGIN
    -- Set the root node
    l_json.put('name', 'Application Home');
    
    -- Get all top-level pages
    FOR r_page IN (
        SELECT p.page_id,
               p.page_name,
               p.page_title,
               p.page_group
        FROM apex_application_pages p
        WHERE p.application_id = 200
        AND p.page_group IS NOT NULL
        AND p.page_id = (
            SELECT MIN(page_id)
            FROM apex_application_pages
            WHERE application_id = 200
            AND page_group = p.page_group
        )
        ORDER BY p.page_id
    ) LOOP
        DECLARE
            l_page JSON_OBJECT_T := JSON_OBJECT_T();
        BEGIN
            l_page.put('name', r_page.page_name);
            l_page.put('pageId', r_page.page_id);
            l_page.put('title', r_page.page_title);
            l_page.put('group', r_page.page_group);
            
            -- Add children
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
                    l_page.put('children', get_child_pages(r_page.page_id));
                END IF;
            END;
            
            l_children.append(l_page);
        END;
    END LOOP;
    
    l_json.put('children', l_children);
    l_result := l_json.to_clob();
    
    RETURN l_result;
END;
/