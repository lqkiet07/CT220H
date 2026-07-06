// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TicketsTable extends Tickets with TableInfo<$TicketsTable, Ticket> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TicketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _movieIdMeta = const VerificationMeta(
    'movieId',
  );
  @override
  late final GeneratedColumn<String> movieId = GeneratedColumn<String>(
    'movie_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookingTimeMeta = const VerificationMeta(
    'bookingTime',
  );
  @override
  late final GeneratedColumn<String> bookingTime = GeneratedColumn<String>(
    'booking_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qrCodeDataMeta = const VerificationMeta(
    'qrCodeData',
  );
  @override
  late final GeneratedColumn<String> qrCodeData = GeneratedColumn<String>(
    'qr_code_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seatIdsMeta = const VerificationMeta(
    'seatIds',
  );
  @override
  late final GeneratedColumn<String> seatIds = GeneratedColumn<String>(
    'seat_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalPriceMeta = const VerificationMeta(
    'totalPrice',
  );
  @override
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
    'total_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    movieId,
    bookingTime,
    qrCodeData,
    seatIds,
    totalPrice,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tickets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ticket> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('movie_id')) {
      context.handle(
        _movieIdMeta,
        movieId.isAcceptableOrUnknown(data['movie_id']!, _movieIdMeta),
      );
    } else if (isInserting) {
      context.missing(_movieIdMeta);
    }
    if (data.containsKey('booking_time')) {
      context.handle(
        _bookingTimeMeta,
        bookingTime.isAcceptableOrUnknown(
          data['booking_time']!,
          _bookingTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bookingTimeMeta);
    }
    if (data.containsKey('qr_code_data')) {
      context.handle(
        _qrCodeDataMeta,
        qrCodeData.isAcceptableOrUnknown(
          data['qr_code_data']!,
          _qrCodeDataMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_qrCodeDataMeta);
    }
    if (data.containsKey('seat_ids')) {
      context.handle(
        _seatIdsMeta,
        seatIds.isAcceptableOrUnknown(data['seat_ids']!, _seatIdsMeta),
      );
    } else if (isInserting) {
      context.missing(_seatIdsMeta);
    }
    if (data.containsKey('total_price')) {
      context.handle(
        _totalPriceMeta,
        totalPrice.isAcceptableOrUnknown(data['total_price']!, _totalPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_totalPriceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ticket map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ticket(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      movieId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}movie_id'],
      )!,
      bookingTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}booking_time'],
      )!,
      qrCodeData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qr_code_data'],
      )!,
      seatIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seat_ids'],
      )!,
      totalPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_price'],
      )!,
    );
  }

  @override
  $TicketsTable createAlias(String alias) {
    return $TicketsTable(attachedDatabase, alias);
  }
}

class Ticket extends DataClass implements Insertable<Ticket> {
  final int id;
  final String movieId;
  final String bookingTime;
  final String qrCodeData;
  final String seatIds;
  final double totalPrice;
  const Ticket({
    required this.id,
    required this.movieId,
    required this.bookingTime,
    required this.qrCodeData,
    required this.seatIds,
    required this.totalPrice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['movie_id'] = Variable<String>(movieId);
    map['booking_time'] = Variable<String>(bookingTime);
    map['qr_code_data'] = Variable<String>(qrCodeData);
    map['seat_ids'] = Variable<String>(seatIds);
    map['total_price'] = Variable<double>(totalPrice);
    return map;
  }

  TicketsCompanion toCompanion(bool nullToAbsent) {
    return TicketsCompanion(
      id: Value(id),
      movieId: Value(movieId),
      bookingTime: Value(bookingTime),
      qrCodeData: Value(qrCodeData),
      seatIds: Value(seatIds),
      totalPrice: Value(totalPrice),
    );
  }

  factory Ticket.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ticket(
      id: serializer.fromJson<int>(json['id']),
      movieId: serializer.fromJson<String>(json['movieId']),
      bookingTime: serializer.fromJson<String>(json['bookingTime']),
      qrCodeData: serializer.fromJson<String>(json['qrCodeData']),
      seatIds: serializer.fromJson<String>(json['seatIds']),
      totalPrice: serializer.fromJson<double>(json['totalPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'movieId': serializer.toJson<String>(movieId),
      'bookingTime': serializer.toJson<String>(bookingTime),
      'qrCodeData': serializer.toJson<String>(qrCodeData),
      'seatIds': serializer.toJson<String>(seatIds),
      'totalPrice': serializer.toJson<double>(totalPrice),
    };
  }

  Ticket copyWith({
    int? id,
    String? movieId,
    String? bookingTime,
    String? qrCodeData,
    String? seatIds,
    double? totalPrice,
  }) => Ticket(
    id: id ?? this.id,
    movieId: movieId ?? this.movieId,
    bookingTime: bookingTime ?? this.bookingTime,
    qrCodeData: qrCodeData ?? this.qrCodeData,
    seatIds: seatIds ?? this.seatIds,
    totalPrice: totalPrice ?? this.totalPrice,
  );
  Ticket copyWithCompanion(TicketsCompanion data) {
    return Ticket(
      id: data.id.present ? data.id.value : this.id,
      movieId: data.movieId.present ? data.movieId.value : this.movieId,
      bookingTime: data.bookingTime.present
          ? data.bookingTime.value
          : this.bookingTime,
      qrCodeData: data.qrCodeData.present
          ? data.qrCodeData.value
          : this.qrCodeData,
      seatIds: data.seatIds.present ? data.seatIds.value : this.seatIds,
      totalPrice: data.totalPrice.present
          ? data.totalPrice.value
          : this.totalPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ticket(')
          ..write('id: $id, ')
          ..write('movieId: $movieId, ')
          ..write('bookingTime: $bookingTime, ')
          ..write('qrCodeData: $qrCodeData, ')
          ..write('seatIds: $seatIds, ')
          ..write('totalPrice: $totalPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, movieId, bookingTime, qrCodeData, seatIds, totalPrice);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ticket &&
          other.id == this.id &&
          other.movieId == this.movieId &&
          other.bookingTime == this.bookingTime &&
          other.qrCodeData == this.qrCodeData &&
          other.seatIds == this.seatIds &&
          other.totalPrice == this.totalPrice);
}

class TicketsCompanion extends UpdateCompanion<Ticket> {
  final Value<int> id;
  final Value<String> movieId;
  final Value<String> bookingTime;
  final Value<String> qrCodeData;
  final Value<String> seatIds;
  final Value<double> totalPrice;
  const TicketsCompanion({
    this.id = const Value.absent(),
    this.movieId = const Value.absent(),
    this.bookingTime = const Value.absent(),
    this.qrCodeData = const Value.absent(),
    this.seatIds = const Value.absent(),
    this.totalPrice = const Value.absent(),
  });
  TicketsCompanion.insert({
    this.id = const Value.absent(),
    required String movieId,
    required String bookingTime,
    required String qrCodeData,
    required String seatIds,
    required double totalPrice,
  }) : movieId = Value(movieId),
       bookingTime = Value(bookingTime),
       qrCodeData = Value(qrCodeData),
       seatIds = Value(seatIds),
       totalPrice = Value(totalPrice);
  static Insertable<Ticket> custom({
    Expression<int>? id,
    Expression<String>? movieId,
    Expression<String>? bookingTime,
    Expression<String>? qrCodeData,
    Expression<String>? seatIds,
    Expression<double>? totalPrice,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (movieId != null) 'movie_id': movieId,
      if (bookingTime != null) 'booking_time': bookingTime,
      if (qrCodeData != null) 'qr_code_data': qrCodeData,
      if (seatIds != null) 'seat_ids': seatIds,
      if (totalPrice != null) 'total_price': totalPrice,
    });
  }

  TicketsCompanion copyWith({
    Value<int>? id,
    Value<String>? movieId,
    Value<String>? bookingTime,
    Value<String>? qrCodeData,
    Value<String>? seatIds,
    Value<double>? totalPrice,
  }) {
    return TicketsCompanion(
      id: id ?? this.id,
      movieId: movieId ?? this.movieId,
      bookingTime: bookingTime ?? this.bookingTime,
      qrCodeData: qrCodeData ?? this.qrCodeData,
      seatIds: seatIds ?? this.seatIds,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (movieId.present) {
      map['movie_id'] = Variable<String>(movieId.value);
    }
    if (bookingTime.present) {
      map['booking_time'] = Variable<String>(bookingTime.value);
    }
    if (qrCodeData.present) {
      map['qr_code_data'] = Variable<String>(qrCodeData.value);
    }
    if (seatIds.present) {
      map['seat_ids'] = Variable<String>(seatIds.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<double>(totalPrice.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TicketsCompanion(')
          ..write('id: $id, ')
          ..write('movieId: $movieId, ')
          ..write('bookingTime: $bookingTime, ')
          ..write('qrCodeData: $qrCodeData, ')
          ..write('seatIds: $seatIds, ')
          ..write('totalPrice: $totalPrice')
          ..write(')'))
        .toString();
  }
}

class $FavoriteMoviesTable extends FavoriteMovies
    with TableInfo<$FavoriteMoviesTable, FavoriteMovie> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteMoviesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _movieIdMeta = const VerificationMeta(
    'movieId',
  );
  @override
  late final GeneratedColumn<String> movieId = GeneratedColumn<String>(
    'movie_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posterUrlMeta = const VerificationMeta(
    'posterUrl',
  );
  @override
  late final GeneratedColumn<String> posterUrl = GeneratedColumn<String>(
    'poster_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [movieId, title, posterUrl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_movies';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoriteMovie> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('movie_id')) {
      context.handle(
        _movieIdMeta,
        movieId.isAcceptableOrUnknown(data['movie_id']!, _movieIdMeta),
      );
    } else if (isInserting) {
      context.missing(_movieIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('poster_url')) {
      context.handle(
        _posterUrlMeta,
        posterUrl.isAcceptableOrUnknown(data['poster_url']!, _posterUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {movieId};
  @override
  FavoriteMovie map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteMovie(
      movieId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}movie_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      posterUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_url'],
      ),
    );
  }

  @override
  $FavoriteMoviesTable createAlias(String alias) {
    return $FavoriteMoviesTable(attachedDatabase, alias);
  }
}

class FavoriteMovie extends DataClass implements Insertable<FavoriteMovie> {
  final String movieId;
  final String title;
  final String? posterUrl;
  const FavoriteMovie({
    required this.movieId,
    required this.title,
    this.posterUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['movie_id'] = Variable<String>(movieId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || posterUrl != null) {
      map['poster_url'] = Variable<String>(posterUrl);
    }
    return map;
  }

  FavoriteMoviesCompanion toCompanion(bool nullToAbsent) {
    return FavoriteMoviesCompanion(
      movieId: Value(movieId),
      title: Value(title),
      posterUrl: posterUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(posterUrl),
    );
  }

  factory FavoriteMovie.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteMovie(
      movieId: serializer.fromJson<String>(json['movieId']),
      title: serializer.fromJson<String>(json['title']),
      posterUrl: serializer.fromJson<String?>(json['posterUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'movieId': serializer.toJson<String>(movieId),
      'title': serializer.toJson<String>(title),
      'posterUrl': serializer.toJson<String?>(posterUrl),
    };
  }

  FavoriteMovie copyWith({
    String? movieId,
    String? title,
    Value<String?> posterUrl = const Value.absent(),
  }) => FavoriteMovie(
    movieId: movieId ?? this.movieId,
    title: title ?? this.title,
    posterUrl: posterUrl.present ? posterUrl.value : this.posterUrl,
  );
  FavoriteMovie copyWithCompanion(FavoriteMoviesCompanion data) {
    return FavoriteMovie(
      movieId: data.movieId.present ? data.movieId.value : this.movieId,
      title: data.title.present ? data.title.value : this.title,
      posterUrl: data.posterUrl.present ? data.posterUrl.value : this.posterUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteMovie(')
          ..write('movieId: $movieId, ')
          ..write('title: $title, ')
          ..write('posterUrl: $posterUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(movieId, title, posterUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteMovie &&
          other.movieId == this.movieId &&
          other.title == this.title &&
          other.posterUrl == this.posterUrl);
}

class FavoriteMoviesCompanion extends UpdateCompanion<FavoriteMovie> {
  final Value<String> movieId;
  final Value<String> title;
  final Value<String?> posterUrl;
  final Value<int> rowid;
  const FavoriteMoviesCompanion({
    this.movieId = const Value.absent(),
    this.title = const Value.absent(),
    this.posterUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoriteMoviesCompanion.insert({
    required String movieId,
    required String title,
    this.posterUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : movieId = Value(movieId),
       title = Value(title);
  static Insertable<FavoriteMovie> custom({
    Expression<String>? movieId,
    Expression<String>? title,
    Expression<String>? posterUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (movieId != null) 'movie_id': movieId,
      if (title != null) 'title': title,
      if (posterUrl != null) 'poster_url': posterUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoriteMoviesCompanion copyWith({
    Value<String>? movieId,
    Value<String>? title,
    Value<String?>? posterUrl,
    Value<int>? rowid,
  }) {
    return FavoriteMoviesCompanion(
      movieId: movieId ?? this.movieId,
      title: title ?? this.title,
      posterUrl: posterUrl ?? this.posterUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (movieId.present) {
      map['movie_id'] = Variable<String>(movieId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (posterUrl.present) {
      map['poster_url'] = Variable<String>(posterUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteMoviesCompanion(')
          ..write('movieId: $movieId, ')
          ..write('title: $title, ')
          ..write('posterUrl: $posterUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TicketsTable tickets = $TicketsTable(this);
  late final $FavoriteMoviesTable favoriteMovies = $FavoriteMoviesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tickets, favoriteMovies];
}

typedef $$TicketsTableCreateCompanionBuilder =
    TicketsCompanion Function({
      Value<int> id,
      required String movieId,
      required String bookingTime,
      required String qrCodeData,
      required String seatIds,
      required double totalPrice,
    });
typedef $$TicketsTableUpdateCompanionBuilder =
    TicketsCompanion Function({
      Value<int> id,
      Value<String> movieId,
      Value<String> bookingTime,
      Value<String> qrCodeData,
      Value<String> seatIds,
      Value<double> totalPrice,
    });

class $$TicketsTableFilterComposer
    extends Composer<_$AppDatabase, $TicketsTable> {
  $$TicketsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get movieId => $composableBuilder(
    column: $table.movieId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookingTime => $composableBuilder(
    column: $table.bookingTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qrCodeData => $composableBuilder(
    column: $table.qrCodeData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seatIds => $composableBuilder(
    column: $table.seatIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TicketsTableOrderingComposer
    extends Composer<_$AppDatabase, $TicketsTable> {
  $$TicketsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get movieId => $composableBuilder(
    column: $table.movieId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookingTime => $composableBuilder(
    column: $table.bookingTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qrCodeData => $composableBuilder(
    column: $table.qrCodeData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seatIds => $composableBuilder(
    column: $table.seatIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TicketsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TicketsTable> {
  $$TicketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get movieId =>
      $composableBuilder(column: $table.movieId, builder: (column) => column);

  GeneratedColumn<String> get bookingTime => $composableBuilder(
    column: $table.bookingTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get qrCodeData => $composableBuilder(
    column: $table.qrCodeData,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seatIds =>
      $composableBuilder(column: $table.seatIds, builder: (column) => column);

  GeneratedColumn<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => column,
  );
}

class $$TicketsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TicketsTable,
          Ticket,
          $$TicketsTableFilterComposer,
          $$TicketsTableOrderingComposer,
          $$TicketsTableAnnotationComposer,
          $$TicketsTableCreateCompanionBuilder,
          $$TicketsTableUpdateCompanionBuilder,
          (Ticket, BaseReferences<_$AppDatabase, $TicketsTable, Ticket>),
          Ticket,
          PrefetchHooks Function()
        > {
  $$TicketsTableTableManager(_$AppDatabase db, $TicketsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TicketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TicketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TicketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> movieId = const Value.absent(),
                Value<String> bookingTime = const Value.absent(),
                Value<String> qrCodeData = const Value.absent(),
                Value<String> seatIds = const Value.absent(),
                Value<double> totalPrice = const Value.absent(),
              }) => TicketsCompanion(
                id: id,
                movieId: movieId,
                bookingTime: bookingTime,
                qrCodeData: qrCodeData,
                seatIds: seatIds,
                totalPrice: totalPrice,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String movieId,
                required String bookingTime,
                required String qrCodeData,
                required String seatIds,
                required double totalPrice,
              }) => TicketsCompanion.insert(
                id: id,
                movieId: movieId,
                bookingTime: bookingTime,
                qrCodeData: qrCodeData,
                seatIds: seatIds,
                totalPrice: totalPrice,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TicketsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TicketsTable,
      Ticket,
      $$TicketsTableFilterComposer,
      $$TicketsTableOrderingComposer,
      $$TicketsTableAnnotationComposer,
      $$TicketsTableCreateCompanionBuilder,
      $$TicketsTableUpdateCompanionBuilder,
      (Ticket, BaseReferences<_$AppDatabase, $TicketsTable, Ticket>),
      Ticket,
      PrefetchHooks Function()
    >;
typedef $$FavoriteMoviesTableCreateCompanionBuilder =
    FavoriteMoviesCompanion Function({
      required String movieId,
      required String title,
      Value<String?> posterUrl,
      Value<int> rowid,
    });
typedef $$FavoriteMoviesTableUpdateCompanionBuilder =
    FavoriteMoviesCompanion Function({
      Value<String> movieId,
      Value<String> title,
      Value<String?> posterUrl,
      Value<int> rowid,
    });

class $$FavoriteMoviesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoriteMoviesTable> {
  $$FavoriteMoviesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get movieId => $composableBuilder(
    column: $table.movieId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterUrl => $composableBuilder(
    column: $table.posterUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FavoriteMoviesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoriteMoviesTable> {
  $$FavoriteMoviesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get movieId => $composableBuilder(
    column: $table.movieId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterUrl => $composableBuilder(
    column: $table.posterUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FavoriteMoviesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoriteMoviesTable> {
  $$FavoriteMoviesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get movieId =>
      $composableBuilder(column: $table.movieId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get posterUrl =>
      $composableBuilder(column: $table.posterUrl, builder: (column) => column);
}

class $$FavoriteMoviesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoriteMoviesTable,
          FavoriteMovie,
          $$FavoriteMoviesTableFilterComposer,
          $$FavoriteMoviesTableOrderingComposer,
          $$FavoriteMoviesTableAnnotationComposer,
          $$FavoriteMoviesTableCreateCompanionBuilder,
          $$FavoriteMoviesTableUpdateCompanionBuilder,
          (
            FavoriteMovie,
            BaseReferences<_$AppDatabase, $FavoriteMoviesTable, FavoriteMovie>,
          ),
          FavoriteMovie,
          PrefetchHooks Function()
        > {
  $$FavoriteMoviesTableTableManager(
    _$AppDatabase db,
    $FavoriteMoviesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoriteMoviesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoriteMoviesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoriteMoviesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> movieId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> posterUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoriteMoviesCompanion(
                movieId: movieId,
                title: title,
                posterUrl: posterUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String movieId,
                required String title,
                Value<String?> posterUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoriteMoviesCompanion.insert(
                movieId: movieId,
                title: title,
                posterUrl: posterUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoriteMoviesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoriteMoviesTable,
      FavoriteMovie,
      $$FavoriteMoviesTableFilterComposer,
      $$FavoriteMoviesTableOrderingComposer,
      $$FavoriteMoviesTableAnnotationComposer,
      $$FavoriteMoviesTableCreateCompanionBuilder,
      $$FavoriteMoviesTableUpdateCompanionBuilder,
      (
        FavoriteMovie,
        BaseReferences<_$AppDatabase, $FavoriteMoviesTable, FavoriteMovie>,
      ),
      FavoriteMovie,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TicketsTableTableManager get tickets =>
      $$TicketsTableTableManager(_db, _db.tickets);
  $$FavoriteMoviesTableTableManager get favoriteMovies =>
      $$FavoriteMoviesTableTableManager(_db, _db.favoriteMovies);
}
