-- BEFORE INSERT trigger
CREATE TRIGGER validate_title_before_insert_certifications
  BEFORE INSERT ON Certifications
BEGIN 
  SELECT 
    CASE 
      WHEN NEW.title != "PMP" AND 
      NEW.title != "CBAP" AND
      NEW.title != "CSM" AND
      NEW.title != "CSTE" AND
      NEW.title != "CAP" THEN 
        RAISE (ABORT, "Invalid title name for certifications")
    END;
END;

-- Create a view
CREATE VIEW AuthorTopic(
    TopicName, 
    AuthorName
) AS 
SELECT 
    Topic.name, 
    Author.name
FROM 
    Topic
INNER JOIN Author USING (aid);

-- INSTEAD OF trigger
CREATE TRIGGER validate_insertion_before_insert_AuthorTopic
    INSTEAD OF INSERT ON AuthorTopic
BEGIN
    INSERT INTO Author(Name)
    VALUES(NEW.AuthorName);
    
    INSERT INTO Topic(name, aid)
    VALUES(NEW.TopicName, last_insert_rowid());
END;