module Api
  module V1
    class OrdersController < ApplicationController
      def index
        if params[:customer_id].present?
          @orders = Order.where(customer_id: params[:customer_id])
        else
          @orders = Order.all
        end

        render json: @orders
      end

      def show
        @order = Order.find(params[:id])

        render json: @order
      end

      def create
        @order = Order.new(customer_id: params[:customer_id], status: "pending")

        if @order.save
          render json: @order, status: :created, location: api_v1_order_url(@order)
        else
          render json: @order.errors, status: :unprocessable_entity
        end
      end

      def ship
        @order = Order.find(params[:id])

        shippable = @order.status != "shipped"

        if shippable
          if @order.update(status: "shipped")
            render json: @order, status: :ok, location: api_v1_order_url(@order)
          else
            render json: @order.errors, status: :unprocessable_entity
          end
        else
          render json: {
            message: "There was a problem shipping your order."
          }
        end
      end
    end
  end
end
