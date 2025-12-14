CREATE OR REPLACE PROCEDURE seed_book_rental_data(
    IN p_member_count  INT  DEFAULT 10000,  -- 会員数（例: 1万）
    IN p_book_count    INT  DEFAULT 1000,   -- 書籍数（例: 1000冊）
    IN p_months        INT  DEFAULT 24      -- データを作る月数（例: 24ヶ月＝2年）
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_month DATE := (
        date_trunc('month', CURRENT_DATE)
        - make_interval(months := p_months)
    )::date;
    v_month              DATE;
    v_rentals_per_month  INT;
BEGIN
    -- 書籍データ投入（p_book_count 冊）
    INSERT INTO book (title, category)
    SELECT
        format('Book %s', gs) AS title,
        CASE ((gs - 1) % 5)
            WHEN 0 THEN 'Business'
            WHEN 1 THEN 'Technology'
            WHEN 2 THEN 'Novel'
            WHEN 3 THEN 'Comic'
            ELSE 'Others'
        END AS category
    FROM generate_series(1, p_book_count) AS gs;

    -- 会員データ投入（p_member_count 人）
    INSERT INTO member (name)
    SELECT format('Member %s', gs) AS name
    FROM generate_series(1, p_member_count) AS gs;

    -- 貸出履歴データ投入
    v_month := v_start_month;
    v_rentals_per_month := (p_member_count / 2) * 8;

    WHILE v_month < date_trunc('month', CURRENT_DATE)::date LOOP
        INSERT INTO rental (book_id, member_id, rented_at)
        SELECT
            (1 + floor(random() * p_book_count))::bigint AS book_id,
            (1 + floor(random() * p_member_count))::bigint AS member_id,
            v_month
                + (floor(random() * 28))::int
                + make_interval(hours := floor(random() * 24)::int) AS rented_at
        FROM generate_series(1, v_rentals_per_month) AS gs;

        v_month := (v_month + INTERVAL '1 month')::date;
    END LOOP;
END;
$$;

CALL seed_book_rental_data();
