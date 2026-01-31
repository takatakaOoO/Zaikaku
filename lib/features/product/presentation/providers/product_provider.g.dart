// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 製品リストの状態を管理するプロバイダー

@ProviderFor(ProductList)
const productListProvider = ProductListProvider._();

/// 製品リストの状態を管理するプロバイダー
final class ProductListProvider
    extends $AsyncNotifierProvider<ProductList, List<ProductWithMaterials>> {
  /// 製品リストの状態を管理するプロバイダー
  const ProductListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productListHash();

  @$internal
  @override
  ProductList create() => ProductList();
}

String _$productListHash() => r'f8c340ae5d8e0a1e30752492f96703a4019a018c';

/// 製品リストの状態を管理するプロバイダー

abstract class _$ProductList
    extends $AsyncNotifier<List<ProductWithMaterials>> {
  FutureOr<List<ProductWithMaterials>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ProductWithMaterials>>,
              List<ProductWithMaterials>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ProductWithMaterials>>,
                List<ProductWithMaterials>
              >,
              AsyncValue<List<ProductWithMaterials>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 単一製品の取得（編集画面用）

@ProviderFor(product)
const productProvider = ProductFamily._();

/// 単一製品の取得（編集画面用）

final class ProductProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProductWithMaterials?>,
          ProductWithMaterials?,
          FutureOr<ProductWithMaterials?>
        >
    with
        $FutureModifier<ProductWithMaterials?>,
        $FutureProvider<ProductWithMaterials?> {
  /// 単一製品の取得（編集画面用）
  const ProductProvider._({
    required ProductFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'productProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productHash();

  @override
  String toString() {
    return r'productProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ProductWithMaterials?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProductWithMaterials?> create(Ref ref) {
    final argument = this.argument as int;
    return product(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productHash() => r'a7ba006b00bbc825dbb539a81d209e5873ffe698';

/// 単一製品の取得（編集画面用）

final class ProductFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ProductWithMaterials?>, int> {
  const ProductFamily._()
    : super(
        retry: null,
        name: r'productProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 単一製品の取得（編集画面用）

  ProductProvider call(int id) => ProductProvider._(argument: id, from: this);

  @override
  String toString() => r'productProvider';
}
