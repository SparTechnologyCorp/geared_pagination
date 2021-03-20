require 'geared_pagination/recordset'
require 'geared_pagination/headers'

module GearedPagination
  module Controller
    extend ActiveSupport::Concern

    included do
      after_action :set_paginated_headers
      etag { @page if geared_page? }
    end

    private
      def set_page_and_extract_portion_from(records, ordered_by: nil, per_page: nil, estimated_count: nil)
        @page = current_page_from(records, ordered_by: ordered_by, per_page: per_page, estimated_count: estimated_count)
        @page.records
      end

      def current_page_from(records, ordered_by: nil, per_page: nil, estimated_count: nil)
        GearedPagination::Recordset.new(records, ordered_by: ordered_by, per_page: per_page, estimated_count: estimated_count).page(current_page_param)
      end

      def set_paginated_headers
        GearedPagination::Headers.new(page: @page, controller: self).apply if geared_page?
      end

      def geared_page?
        @page.is_a? GearedPagination::Page
      end

      def current_page_param
        params[:page]
      end
  end
end
