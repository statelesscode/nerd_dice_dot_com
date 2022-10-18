# This enables the pgcrypto extension so you can have UUID columns
class AddUuidSupport < ActiveRecord::Migration[7.0]
  def change
    enable_extension "pgcrypto"
  end
end
