-- ============================================
-- PL/SQL MINI PROJECT
-- STUDENT RESULT MANAGEMENT SYSTEM
-- ============================================

-- 1. CREATE TABLE

CREATE TABLE STUDENT_RESULT (
    STUDENT_ID NUMBER PRIMARY KEY,
    STUDENT_NAME VARCHAR2(50),
    COURSE VARCHAR2(50),
    MARKS1 NUMBER,
    MARKS2 NUMBER,
    MARKS3 NUMBER,
    TOTAL NUMBER,
    PERCENTAGE NUMBER(5,2),
    GRADE VARCHAR2(10)
);


-- ============================================
-- 2. INSERT STUDENT DATA
-- ============================================

INSERT INTO STUDENT_RESULT
(STUDENT_ID, STUDENT_NAME, COURSE, MARKS1, MARKS2, MARKS3)
VALUES
(101, 'Poonam', 'MCA Data Science', 85, 90, 88);

INSERT INTO STUDENT_RESULT
(STUDENT_ID, STUDENT_NAME, COURSE, MARKS1, MARKS2, MARKS3)
VALUES
(102, 'Rahul', 'MCA Data Science', 75, 80, 78);

INSERT INTO STUDENT_RESULT
(STUDENT_ID, STUDENT_NAME, COURSE, MARKS1, MARKS2, MARKS3)
VALUES
(103, 'Neha', 'MCA Data Science', 92, 95, 90);

INSERT INTO STUDENT_RESULT
(STUDENT_ID, STUDENT_NAME, COURSE, MARKS1, MARKS2, MARKS3)
VALUES
(104, 'Aman', 'MCA Data Science', 65, 70, 68);

COMMIT;


-- ============================================
-- 3. PROCEDURE TO CALCULATE RESULT
-- ============================================

CREATE OR REPLACE PROCEDURE CALCULATE_RESULT
IS
BEGIN

    UPDATE STUDENT_RESULT
    SET
        TOTAL = MARKS1 + MARKS2 + MARKS3,

        PERCENTAGE = (MARKS1 + MARKS2 + MARKS3) / 3,

        GRADE =
            CASE
                WHEN (MARKS1 + MARKS2 + MARKS3) / 3 >= 90
                    THEN 'A+'

                WHEN (MARKS1 + MARKS2 + MARKS3) / 3 >= 80
                    THEN 'A'

                WHEN (MARKS1 + MARKS2 + MARKS3) / 3 >= 70
                    THEN 'B'

                WHEN (MARKS1 + MARKS2 + MARKS3) / 3 >= 60
                    THEN 'C'

                WHEN (MARKS1 + MARKS2 + MARKS3) / 3 >= 50
                    THEN 'D'

                ELSE 'F'
            END;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Result calculated successfully.');

END;
/


-- ============================================
-- 4. EXECUTE PROCEDURE
-- ============================================

BEGIN
    CALCULATE_RESULT;
END;
/


-- ============================================
-- 5. DISPLAY ALL RESULTS
-- ============================================

SELECT
    STUDENT_ID,
    STUDENT_NAME,
    COURSE,
    MARKS1,
    MARKS2,
    MARKS3,
    TOTAL,
    PERCENTAGE,
    GRADE
FROM STUDENT_RESULT
ORDER BY STUDENT_ID;


-- ============================================
-- 6. FUNCTION TO GET GRADE
-- ============================================

CREATE OR REPLACE FUNCTION GET_GRADE
(
    P_PERCENTAGE NUMBER
)
RETURN VARCHAR2
IS
BEGIN

    IF P_PERCENTAGE >= 90 THEN
        RETURN 'A+';

    ELSIF P_PERCENTAGE >= 80 THEN
        RETURN 'A';

    ELSIF P_PERCENTAGE >= 70 THEN
        RETURN 'B';

    ELSIF P_PERCENTAGE >= 60 THEN
        RETURN 'C';

    ELSIF P_PERCENTAGE >= 50 THEN
        RETURN 'D';

    ELSE
        RETURN 'F';
    END IF;

END;
/


-- ============================================
-- 7. TEST FUNCTION
-- ============================================

SELECT
    STUDENT_NAME,
    PERCENTAGE,
    GET_GRADE(PERCENTAGE) AS GRADE
FROM STUDENT_RESULT;


-- ============================================
-- 8. CURSOR TO DISPLAY STUDENT RESULTS
-- ============================================

DECLARE

    CURSOR student_cursor IS
        SELECT STUDENT_ID, STUDENT_NAME,
               PERCENTAGE, GRADE
        FROM STUDENT_RESULT;

BEGIN

    FOR student IN student_cursor
    LOOP

        DBMS_OUTPUT.PUT_LINE(
            'ID: ' || student.STUDENT_ID ||
            ' | Name: ' || student.STUDENT_NAME ||
            ' | Percentage: ' || student.PERCENTAGE ||
            ' | Grade: ' || student.GRADE
        );

    END LOOP;

END;
/


-- ============================================
-- 9. EXCEPTION HANDLING
-- ============================================

DECLARE

    v_percentage NUMBER;

BEGIN

    SELECT PERCENTAGE
    INTO v_percentage
    FROM STUDENT_RESULT
    WHERE STUDENT_ID = 101;

    DBMS_OUTPUT.PUT_LINE(
        'Percentage: ' || v_percentage
    );

EXCEPTION

    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Student not found.');

    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Multiple students found.');

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred.');

END;
/


-- ============================================
-- 10. UPDATE STUDENT MARKS
-- ============================================

UPDATE STUDENT_RESULT
SET MARKS1 = 88
WHERE STUDENT_ID = 101;

COMMIT;


-- Recalculate after update

BEGIN
    CALCULATE_RESULT;
END;
/


-- ============================================
-- 11. DISPLAY UPDATED RESULT
-- ============================================

SELECT *
FROM STUDENT_RESULT
ORDER BY STUDENT_ID;


-- ============================================
-- 12. DELETE A STUDENT
-- ============================================

DELETE FROM STUDENT_RESULT
WHERE STUDENT_ID = 104;

COMMIT;


-- ============================================
-- 13. FINAL RESULT
-- ============================================

SELECT
    STUDENT_ID,
    STUDENT_NAME,
    COURSE,
    TOTAL,
    ROUND(PERCENTAGE, 2) AS PERCENTAGE,
    GRADE
FROM STUDENT_RESULT
ORDER BY PERCENTAGE DESC;