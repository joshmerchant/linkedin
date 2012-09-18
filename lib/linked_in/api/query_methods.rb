module LinkedIn
  module Api

    module QueryMethods

      def profile(options={})
        path = person_path(options)
        simple_query(path, options)
      end

      def connections(options={})
        path = "#{person_path(options)}/connections"
        simple_query(path, options)
      end

      def network_updates(options={})
        path = "#{person_path(options)}/network/updates"
        simple_query(path, options)
      end

      def company(options = {})
        path   = company_path(options)
        simple_query(path, options)
      end

      def company_updates(options = {})
          path = company_updates_path(options)
          simple_query(path, options)
      end

      def company_search(options = {})
          path = company_search_path(options)
          simple_query(path,options)
      end

      def group_memberships(options = {})
        path = "#{person_path(options)}/group-memberships"
        simple_query(path, options)
      end
      
      def shares(options={})
        path = "#{person_path(options)}/network/updates?type=SHAR&scope=self"
        simple_query(path, options)
      end

      def share_comments(update_key, options={})
        path = "#{person_path(options)}/network/updates/key=#{update_key}/update-comments"
        simple_query(path, options)
      end

      def share_likes(update_key, options={})
        path = "#{person_path(options)}/network/updates/key=#{update_key}/likes"
        simple_query(path, options)
      end

      private

        def simple_query(path, options={})
          fields = options.delete(:fields) || LinkedIn.default_profile_fields

          if options.delete(:public)
            path +=":public"
          elsif fields
            path +=":(#{fields.map{ |f| f.to_s.gsub("_","-") }.join(',')})"
          end

          headers = options.delete(:headers) || {}
          params  = options.map { |k,v| "#{k}=#{v}" }.join("&")
          path   += "?#{params}" if not params.empty?

          Mash.from_json(get(path, headers))
        end

        def person_path(options)
          path = "/people/"
          if id = options.delete(:id)
            path += "id=#{id}"
          elsif url = options.delete(:url)
            path += "url=#{CGI.escape(url)}"
          else
            path += "~"
          end
      end

      def company_updates_path(options)
          path = "/companies"
          if id = options.delete(:id)
              path += "/#{id}"
          else
              return '' 
          end
          path += "/updates?"
          if event_type = options.delete(:event_type)
              path += "event-type=#{event_type}" 
          end
          if path.reverse[0] =~ /\&/
              path += '&' 
          end
          if start = options.delete(:start)
              path += "start=#{start}" 
          end
          path
      end

      def company_search_path(options)
          path = "/company-search?"
          if keywords = options.delete(:keywords)
              path += "keywords=#{CGI.escape keywords}"
          end
          path
      end

      def company_path(options)
          path = "/companies/"
          if id = options.delete(:id)
            path += "id=#{id}"
          elsif url = options.delete(:url)
            path += "url=#{CGI.escape(url)}"
          elsif name = options.delete(:name)
            path += "universal-name=#{CGI.escape(name)}"
          elsif domain = options.delete(:domain)
            path += "email-domain=#{CGI.escape(domain)}"
          else
            path += "~"
          end
        end

    end

  end
end
