# frozen_string_literal: true

ActiveRecord::Schema.define do
  # Set up any tables you need to exist for your test suite that don't belong
  # in migrations.

  create_table "emails", force: :cascade do |t|
    t.datetime "sent_at", precision: nil
    t.text "delivery_errors", default: [], array: true
  end
end
