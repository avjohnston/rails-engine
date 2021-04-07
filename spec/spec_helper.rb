# This file was generated by the `rails generate rspec:install` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause
# this file to always be loaded, without a need to explicitly require it in any
# files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, consider making
# a separate helper file that requires the additional dependencies and performs
# the additional setup, and require it from the spec files that actually need
# it.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

# The settings below are suggested to provide a good initial experience
# with RSpec, but feel free to customize to your heart's content.
=begin
  # This allows you to limit a spec run to individual examples or groups
  # you care about by tagging them with `:focus` metadata. When nothing
  # is tagged with `:focus`, all examples get run. RSpec also provides
  # aliases for `it`, `describe`, and `context` that include `:focus`
  # metadata: `fit`, `fdescribe` and `fcontext`, respectively.
  config.filter_run_when_matching :focus

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = "spec/examples.txt"

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  #   - http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
  #   - http://www.teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/#zero-monkey-patching-mode
  config.disable_monkey_patching!

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = "doc"
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
=end

def setup_five_merchants_revenue
    merchant_1_with_history
    merchant_2_with_history
    merchant_3_with_history
    merchant_4_with_history
    merchant_5_with_history
  end

  def merchant_1_with_history
    @merchant_1 = create(:merchant, name: 'Merchant 1')
    @customer_1 = create(:customer)
    @item_1 = @merchant_1.items.create!(name: 'Item 1', description: 'foo bar baz quux', unit_price: 10)
    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 1, merchant_id: @merchant_1.id)
    InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10)
    Transaction.create!(invoice_id: @invoice_1.id, result: 'success')
  end

  def merchant_2_with_history
    @merchant_2 = create(:merchant, name: 'Merchant 2')
    @customer_2 = create(:customer)
    @item_2 = @merchant_2.items.create!(name: 'Item 2', description: 'foo bar baz quux', unit_price: 10)
    @invoice_2 = Invoice.create!(customer_id: @customer_2.id, status: 1, merchant_id: @merchant_2.id)
    InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, quantity: 2, unit_price: 20)
    Transaction.create!(invoice_id: @invoice_2.id, result: 'success')
  end

  def merchant_3_with_history
    @merchant_3 = create(:merchant, name: 'Merchant 3')
    @customer_3 = create(:customer)
    @item_3 = @merchant_3.items.create!(name: 'Item 3', description: 'foo bar baz quux', unit_price: 20)
    @invoice_3 = Invoice.create!(customer_id: @customer_3.id, status: 1, merchant_id: @merchant_3.id)
    InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_3.id, quantity: 3, unit_price: 30)
    Transaction.create!(invoice_id: @invoice_3.id, result: 'success')
  end

  def merchant_4_with_history
    @merchant_4 = create(:merchant, name: 'Merchant 4')
    @customer_4 = create(:customer)
    @item_4 = @merchant_4.items.create!(name: 'Item 4', description: 'foo bar baz quux', unit_price: 10)
    @item_5 = @merchant_4.items.create!(name: 'Item 5', description: 'foo bar baz quux', unit_price: 20)
    @invoice_4 = Invoice.create!(customer_id: @customer_4.id, status: 1, merchant_id: @merchant_4.id)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 1, merchant_id: @merchant_4.id)
    InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 4, unit_price: 40)
    InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_5.id, quantity: 4, unit_price: 40)
    # Note first transaction is failed
    Transaction.create!(invoice_id: @invoice_4.id, result: 'failed')
    Transaction.create!(invoice_id: @invoice_5.id, result: 'success')
  end

  def merchant_5_with_history
    @merchant_5 = create(:merchant, name: 'Merchant 5 The Homie')
    @customer_5 = create(:customer)
    @item_6 = @merchant_5.items.create!(name: 'Item 6', description: 'foo bar baz quux', unit_price: 10)
    @item_7 = @merchant_5.items.create!(name: 'Item 7 Dude', description: 'foo bar baz quux', unit_price: 20)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 1, merchant_id: @merchant_5.id)
    @invoice_7 = Invoice.create!(customer_id: @customer_5.id, status: 1, merchant_id: @merchant_5.id)
    InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_6.id, quantity: 5, unit_price: 50)
    InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_6.id, quantity: 5, unit_price: 50)
    # Note second transaction is failed
    Transaction.create!(invoice_id: @invoice_6.id, result: 'success')
    Transaction.create!(invoice_id: @invoice_7.id, result: 'failed')
  end

  def merchant_6_with_history
    @merchant_6 = create(:merchant, name: 'Merchant 6')
    @customer_6 = create(:customer)
    @item_8 = @merchant_6.items.create!(name: 'Item 8', description: 'foo bar baz quux', unit_price: 10000)
    @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 1, merchant_id: @merchant_6.id)
    InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_8.id, quantity: 100, unit_price: 10000)
    Transaction.create!(invoice_id: @invoice_8.id, result: 'success')
  end
end
