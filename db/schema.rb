# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170212013315) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cashdesks", force: :cascade do |t|
    t.integer  "number",          null: false
    t.string   "system_name",     null: false
    t.string   "cc_label",        null: false
    t.string   "nis_label",       null: false
    t.string   "eur_label",       null: false
    t.string   "usd_label",       null: false
    t.string   "pelecard_ShopNo", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "icount_flags", force: :cascade do |t|
    t.boolean "use_icount"
  end

  create_table "incomes", force: :cascade do |t|
    t.float    "amount",      default: 0.0,   null: false
    t.string   "kind",                        null: false
    t.string   "currency",    default: "ILS", null: false
    t.string   "name",        default: ""
    t.boolean  "success",     default: false, null: false
    t.boolean  "cancelled",   default: false, null: false
    t.string   "invoice_url"
    t.integer  "shift_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["shift_id"], name: "index_incomes_on_shift_id", using: :btree
  end

  create_table "pelecards", force: :cascade do |t|
    t.string   "confirmation_key"
    t.string   "user_key"
    t.string   "transaction_id"
    t.integer  "status_code"
    t.integer  "cashdesk"
    t.integer  "shift"
    t.string   "approval_no"
    t.string   "shva_result"
    t.string   "voucher_id"
    t.string   "transaction_pelecard_id"
    t.string   "shva_file_number"
    t.string   "station_number"
    t.string   "receipt"
    t.string   "j_param"
    t.string   "cc_number"
    t.string   "cc_exp_date"
    t.string   "cc_company_clearer"
    t.string   "cc_company_issuer"
    t.string   "credit_type"
    t.string   "cc_abroad_card"
    t.string   "debit_type"
    t.string   "debit_code"
    t.string   "debit_total"
    t.string   "debit_currency"
    t.string   "total_payments"
    t.string   "first_payment_total"
    t.string   "fixed_payment_total"
    t.string   "cc_brand"
    t.string   "cc_hebrew_name"
    t.string   "shva_output"
    t.string   "approved_by"
    t.string   "transaction_init_time"
    t.string   "transaction_update_time"
    t.integer  "income_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["income_id"], name: "index_pelecards_on_income_id", using: :btree
  end

  create_table "shifts", force: :cascade do |t|
    t.string   "state"
    t.integer  "cashdesk_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["cashdesk_id"], name: "index_shifts_on_cashdesk_id", using: :btree
  end

  add_foreign_key "incomes", "shifts"
  add_foreign_key "pelecards", "incomes"
  add_foreign_key "shifts", "cashdesks"
end
