# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_10_22_021615) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
  end

  create_table "challenge_results", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "total_questions", default: 10, null: false
    t.integer "correct_answers", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_challenge_results_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["latitude", "longitude"], name: "index_locations_on_latitude_and_longitude", unique: true
  end

  create_table "quiz_histories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "location1_id", null: false
    t.bigint "location2_id", null: false
    t.float "user_answer", null: false
    t.float "correct_answer", null: false
    t.boolean "is_correct", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "mode", null: false
    t.index ["location1_id"], name: "index_quiz_histories_on_location1_id"
    t.index ["location2_id"], name: "index_quiz_histories_on_location2_id"
    t.index ["user_id", "created_at"], name: "index_quiz_histories_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_quiz_histories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "challenge_results", "users"
  add_foreign_key "quiz_histories", "locations", column: "location1_id"
  add_foreign_key "quiz_histories", "locations", column: "location2_id"
  add_foreign_key "quiz_histories", "users"
end
