from rest_framework import serializers

from order.models import Order
from product.models import Product
from product.serializers.product_serializer import ProductSerializer


class OrderSerializer(serializers.ModelSerializer):
    product = ProductSerializer(read_only=True, many=True)
    products_id = serializers.PrimaryKeyRelatedField(
        queryset=Product.objects.all(), write_only=True, many=True
    )
    total = serializers.SerializerMethodField()

    class Meta:
        model = Order
        fields = ["product", "total", "user", "products_id"]
        extra_kwargs = {"product": {"required": False}}

    def get_total(self, instance):
        return sum(product.price for product in instance.product.all())

    def create(self, validated_data):
        product_data = validated_data.pop("products_id")
        user_data = validated_data.pop("user")

        order = Order.objects.create(user=user_data)
        order.product.set(product_data)

        return order
