class CheckoutSubdomain
    def self.matches? request
        case request.subdomain
        when 'checkout'
            true
        else
            false
        end
    end   
end