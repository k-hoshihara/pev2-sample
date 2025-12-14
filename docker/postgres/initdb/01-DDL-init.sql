-- 書籍マスタ
CREATE TABLE book (
    book_id      BIGSERIAL PRIMARY KEY,
    title        TEXT        NOT NULL,
    category     TEXT
);

-- 会員マスタ
CREATE TABLE member (
    member_id BIGSERIAL PRIMARY KEY,
    name      TEXT        NOT NULL
);

-- 貸出履歴
-- ※あえて、インデックスは主キーのみとする
CREATE TABLE rental (
    rental_id   BIGSERIAL PRIMARY KEY,
    book_id     BIGINT     NOT NULL REFERENCES book(book_id),
    member_id   BIGINT     NOT NULL REFERENCES member(member_id),
    rented_at   TIMESTAMPTZ NOT NULL    -- 貸出日時
);

-- パフォーマンス改善用インデックス1
CREATE INDEX idx_rental_1
    ON rental (rented_at, book_id);

