--
-- Package "PCK_USER"
--
CREATE OR REPLACE EDITIONABLE PACKAGE "WKSP_THARUN"."PCK_USER" AS
    -- Encode text for URL parameters
    function fEncode(aString in varchar2) return varchar2;
    
    -- Generate a simple token
    function fGenerateToken(aUserId in number) return varchar2;
    
    -- Generate email link
    function fCreateMailLink(aUserId in number) return varchar2;
    
    -- Create HTML email content
    function fCreateMailContent(aUserId in number) return varchar2;
    
    -- Send emails directly
    procedure pSendUserMail(aUserId in number);
END PCK_USER;
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WKSP_THARUN"."PCK_USER" AS
    -- Encode text for URL parameters
    function fEncode(aString in varchar2) return varchar2 is
    begin
        return apex_escape.html(replace(replace(apex_util.url_encode(aString),'+','%20'),chr(10),'%0D'));    
    end fEncode;
    
    -- Generate a simple token
    function fGenerateToken(aUserId in number) return varchar2 is
        lToken varchar2(100);
        lDateStr varchar2(50);
    begin
        -- Create a string with user ID and current date/time
        lDateStr := TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');
        
        -- Create a simple token
        lToken := TO_CHAR(aUserId) || '-' || lDateStr || '-' || TO_CHAR(MOD(ABS(DBMS_RANDOM.RANDOM), 10000));
        
        return lToken;
    end fGenerateToken;
    
    -- Generate email link
    function fCreateMailLink(aUserId in number) return varchar2 is
        lMailLink varchar2(4000 char); 
        cSubject constant varchar2(2000 char) := 'Please check your user details';
        lBody_DE varchar2(2000 char);
        lBody varchar2(4000 char);
    begin
        for x in (
            select user_id, email, first_name, surname
            from t_user
            where user_id = aUserId
            and status = 10 -- Assuming status 10 is active
        ) loop
            -- Email body text in German
            lBody_DE := 'Sehr geehrte/r ' || x.first_name || ' ' || x.surname || ',' || chr(10) || chr(10) ||
                'Im Prozess XYZ ist festgelegt, dass quartalsweise Ihre Benutzerinformationen bestätigt werden müssen.' || chr(10) || chr(10) ||
                'Bitte bestätigen Sie Ihre Benutzerinformationen im System.' || chr(10) || 
                'Klicken Sie bitte auf den Link, um zu einer Maske weitergeleitet zu werden, in der Sie Ihre Informationen prüfen können.' || chr(10) || chr(10) ||
                'Hilfestellungen zum System finden Sie direkt in der Maske über die ? Icons!' || chr(10) || chr(10) ||
                '1. Bitte klicken Sie den Link um zu Ihrer individuellen Seite zu kommen' || chr(10) ||
                '2. Bitte überprüfen Sie Ihre Informationen' || chr(10) ||
                '3. Bitte klicken Sie auf "Approve", wenn Ihre Informationen korrekt sind' || chr(10) ||
                '4. Falls Änderungen notwendig sind, klicken Sie bitte auf "Edit" und aktualisieren Sie Ihre Daten' || chr(10) || chr(10) ||
                'Link: ' || 'https://yourdomain.com/app/user?id=' || x.user_id || chr(10) || chr(10) ||
                'Vielen Dank für Ihre Unterstützung.';

            -- Combine both texts with separator
            lBody := lBody_DE || chr(10) || chr(10);
                
            -- Create the mail link with escaped characters
            lMailLink := 'mailto:' || x.email || 
                        '?subject=' || fEncode(cSubject) || 
                        '&body=' || fEncode(lBody);
        end loop;

        return lMailLink;
    end fCreateMailLink;
    
    -- Function to create HTML email content
    function fCreateMailContent(aUserId in number) return varchar2 is
        lBody_DE varchar2(4000 char);   
        lBody varchar2(4000 char);
    begin
        for x in (
            select user_id, email, first_name, surname
            from t_user
            where user_id = aUserId
            and status = 10
        ) loop
            -- Email body text in German with HTML formatting
            lBody_DE := 'Sehr geehrte/r ' || x.first_name || ' ' || x.surname || ',' || '<br><br>' ||
                'Im Prozess <span style="color:red;">XYZ</span> ist festgelegt, dass quartalsweise Ihre Benutzerinformationen bestätigt werden müssen.' || '<br><br>' ||
                'Bitte bestätigen Sie Ihre Benutzerinformationen im System.' || '<br>' || 
                'Klicken Sie bitte auf den Link, um zu einer Maske weitergeleitet zu werden, in der Sie Ihre Informationen prüfen können.' || '<br><br>' ||
                'Hilfestellungen zum System finden Sie direkt in der Maske über die ? Icons!' || '<br><br>' ||
                '1. Bitte klicken Sie den Link um zu Ihrer individuellen Seite zu kommen' || '<br>' ||
                '2. Bitte überprüfen Sie Ihre Informationen' || '<br>' ||
                '3. Bitte klicken Sie auf <span style="text-decoration:underline;"><strong>"Approve"</strong></span>, wenn Ihre Informationen korrekt sind' || '<br>' ||
                '4. Falls Änderungen notwendig sind, klicken Sie bitte auf <span style="text-decoration:underline;"><strong>"Edit"</strong></span> und aktualisieren Sie Ihre Daten' || '<br><br>' ||
                'Link: <a href="https://yourdomain.com/app/user?id=' || x.user_id || '">https://yourdomain.com/app/user?id=' || x.user_id || '</a>' || '<br><br>' ||
                'Vielen Dank für Ihre Unterstützung.';

            -- Combine text
            lBody := lBody_DE;
        end loop;
        
        return lBody;
    end fCreateMailContent;
    
    -- Send emails directly
    procedure pSendUserMail(aUserId in number) is
        cSubject constant varchar2(2000 char) := 'User Verification Required';
        lBody varchar2(4000 char);
        lMail number;
        cFrom constant varchar2(250) := 'tharunkommaddi@gmail.com';
    begin
        apex_util.set_security_group_id(p_security_group_id => apex_util.find_security_group_id(p_workspace => 'THARUN'));
        
        for x in (
            select user_id, email
            from t_user
            where user_id = aUserId
            and status = 10
        ) loop
            lBody := fCreateMailContent(aUserId);
            
            -- Email sending logic commented out for safety
            /* 
            lMail := apex_mail.send(
                p_to        => x.email,
                p_from      => cFrom,
                p_body      => lBody,
                p_body_html => lBody,
                p_subj      => cSubject
            );
            */
        end loop;
        
        commit;
        APEX_MAIL.PUSH_QUEUE;
    end pSendUserMail;
END PCK_USER;
/