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
  static const VerificationMeta _movieTitleMeta = const VerificationMeta(
    'movieTitle',
  );
  @override
  late final GeneratedColumn<String> movieTitle = GeneratedColumn<String>(
    'movie_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _showtimeMeta = const VerificationMeta(
    'showtime',
  );
  @override
  late final GeneratedColumn<String> showtime = GeneratedColumn<String>(
    'showtime',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seatNumbersMeta = const VerificationMeta(
    'seatNumbers',
  );
  @override
  late final GeneratedColumn<String> seatNumbers = GeneratedColumn<String>(
    'seat_numbers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qrCodeMeta = const VerificationMeta('qrCode');
  @override
  late final GeneratedColumn<String> qrCode = GeneratedColumn<String>(
    'qr_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    movieId,
    movieTitle,
    showtime,
    seatNumbers,
    qrCode,
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
    if (data.containsKey('movie_title')) {
      context.handle(
        _movieTitleMeta,
        movieTitle.isAcceptableOrUnknown(data['movie_title']!, _movieTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_movieTitleMeta);
    }
    if (data.containsKey('showtime')) {
      context.handle(
        _showtimeMeta,
        showtime.isAcceptableOrUnknown(data['showtime']!, _showtimeMeta),
      );
    } else if (isInserting) {
      context.missing(_showtimeMeta);
    }
    if (data.containsKey('seat_numbers')) {
      context.handle(
        _seatNumbersMeta,
        seatNumbers.isAcceptableOrUnknown(
          data['seat_numbers']!,
          _seatNumbersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_seatNumbersMeta);
    }
    if (data.containsKey('qr_code')) {
      context.handle(
        _qrCodeMeta,
        qrCode.isAcceptableOrUnknown(data['qr_code']!, _qrCodeMeta),
      );
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
      movieTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}movie_title'],
      )!,
      showtime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}showtime'],
      )!,
      seatNumbers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seat_numbers'],
      )!,
      qrCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qr_code'],
      ),
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
  final String movieTitle;
  final String showtime;
  final String seatNumbers;
  final String? qrCode;
  const Ticket({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.showtime,
    required this.seatNumbers,
    this.qrCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['movie_id'] = Variable<String>(movieId);
    map['movie_title'] = Variable<String>(movieTitle);
    map['showtime'] = Variable<String>(showtime);
    map['seat_numbers'] = Variable<String>(seatNumbers);
    if (!nullToAbsent || qrCode != null) {
      map['qr_code'] = Variable<String>(qrCode);
    }
    return map;
  }

  TicketsCompanion toCompanion(bool nullToAbsent) {
    return TicketsCompanion(
      id: Value(id),
      movieId: Value(movieId),
      movieTitle: Value(movieTitle),
      showtime: Value(showtime),
      seatNumbers: Value(seatNumbers),
      qrCode: qrCode == null && nullToAbsent
          ? const Value.absent()
          : Value(qrCode),
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
      movieTitle: serializer.fromJson<String>(json['movieTitle']),
      showtime: serializer.fromJson<String>(json['showtime']),
      seatNumbers: serializer.fromJson<String>(json['seatNumbers']),
      qrCode: serializer.fromJson<String?>(json['qrCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'movieId': serializer.toJson<String>(movieId),
      'movieTitle': serializer.toJson<String>(movieTitle),
      'showtime': serializer.toJson<String>(showtime),
      'seatNumbers': serializer.toJson<String>(seatNumbers),
      'qrCode': serializer.toJson<String?>(qrCode),
    };
  }

  Ticket copyWith({
    int? id,
    String? movieId,
    String? movieTitle,
    String? showtime,
    String? seatNumbers,
    Value<String?> qrCode = const Value.absent(),
  }) => Ticket(
    id: id ?? this.id,
    movieId: movieId ?? this.movieId,
    movieTitle: movieTitle ?? this.movieTitle,
    showtime: showtime ?? this.showtime,
    seatNumbers: seatNumbers ?? this.seatNumbers,
    qrCode: qrCode.present ? qrCode.value : this.qrCode,
  );
  Ticket copyWithCompanion(TicketsCompanion data) {
    return Ticket(
      id: data.id.present ? data.id.value : this.id,
      movieId: data.movieId.present ? data.movieId.value : this.movieId,
      movieTitle: data.movieTitle.present
          ? data.movieTitle.value
          : this.movieTitle,
      showtime: data.showtime.present ? data.showtime.value : this.showtime,
      seatNumbers: data.seatNumbers.present
          ? data.seatNumbers.value
          : this.seatNumbers,
      qrCode: data.qrCode.present ? data.qrCode.value : this.qrCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ticket(')
          ..write('id: $id, ')
          ..write('movieId: $movieId, ')
          ..write('movieTitle: $movieTitle, ')
          ..write('showtime: $showtime, ')
          ..write('seatNumbers: $seatNumbers, ')
          ..write('qrCode: $qrCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, movieId, movieTitle, showtime, seatNumbers, qrCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ticket &&
          other.id == this.id &&
          other.movieId == this.movieId &&
          other.movieTitle == this.movieTitle &&
          other.showtime == this.showtime &&
          other.seatNumbers == this.seatNumbers &&
          other.qrCode == this.qrCode);
}

class TicketsCompanion extends UpdateCompanion<Ticket> {
  final Value<int> id;
  final Value<String> movieId;
  final Value<String> movieTitle;
  final Value<String> showtime;
  final Value<String> seatNumbers;
  final Value<String?> qrCode;
  const TicketsCompanion({
    this.id = const Value.absent(),
    this.movieId = const Value.absent(),
    this.movieTitle = const Value.absent(),
    this.showtime = const Value.absent(),
    this.seatNumbers = const Value.absent(),
    this.qrCode = const Value.absent(),
  });
  TicketsCompanion.insert({
    this.id = const Value.absent(),
    required String movieId,
    required String movieTitle,
    required String showtime,
    required String seatNumbers,
    this.qrCode = const Value.absent(),
  }) : movieId = Value(movieId),
       movieTitle = Value(movieTitle),
       showtime = Value(showtime),
       seatNumbers = Value(seatNumbers);
  static Insertable<Ticket> custom({
    Expression<int>? id,
    Expression<String>? movieId,
    Expression<String>? movieTitle,
    Expression<String>? showtime,
    Expression<String>? seatNumbers,
    Expression<String>? qrCode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (movieId != null) 'movie_id': movieId,
      if (movieTitle != null) 'movie_title': movieTitle,
      if (showtime != null) 'showtime': showtime,
      if (seatNumbers != null) 'seat_numbers': seatNumbers,
      if (qrCode != null) 'qr_code': qrCode,
    });
  }

  TicketsCompanion copyWith({
    Value<int>? id,
    Value<String>? movieId,
    Value<String>? movieTitle,
    Value<String>? showtime,
    Value<String>? seatNumbers,
    Value<String?>? qrCode,
  }) {
    return TicketsCompanion(
      id: id ?? this.id,
      movieId: movieId ?? this.movieId,
      movieTitle: movieTitle ?? this.movieTitle,
      showtime: showtime ?? this.showtime,
      seatNumbers: seatNumbers ?? this.seatNumbers,
      qrCode: qrCode ?? this.qrCode,
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
    if (movieTitle.present) {
      map['movie_title'] = Variable<String>(movieTitle.value);
    }
    if (showtime.present) {
      map['showtime'] = Variable<String>(showtime.value);
    }
    if (seatNumbers.present) {
      map['seat_numbers'] = Variable<String>(seatNumbers.value);
    }
    if (qrCode.present) {
      map['qr_code'] = Variable<String>(qrCode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TicketsCompanion(')
          ..write('id: $id, ')
          ..write('movieId: $movieId, ')
          ..write('movieTitle: $movieTitle, ')
          ..write('showtime: $showtime, ')
          ..write('seatNumbers: $seatNumbers, ')
          ..write('qrCode: $qrCode')
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
      required String movieTitle,
      required String showtime,
      required String seatNumbers,
      Value<String?> qrCode,
    });
typedef $$TicketsTableUpdateCompanionBuilder =
    TicketsCompanion Function({
      Value<int> id,
      Value<String> movieId,
      Value<String> movieTitle,
      Value<String> showtime,
      Value<String> seatNumbers,
      Value<String?> qrCode,
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

  ColumnFilters<String> get movieTitle => $composableBuilder(
    column: $table.movieTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get showtime => $composableBuilder(
    column: $table.showtime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seatNumbers => $composableBuilder(
    column: $table.seatNumbers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qrCode => $composableBuilder(
    column: $table.qrCode,
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

  ColumnOrderings<String> get movieTitle => $composableBuilder(
    column: $table.movieTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get showtime => $composableBuilder(
    column: $table.showtime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seatNumbers => $composableBuilder(
    column: $table.seatNumbers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qrCode => $composableBuilder(
    column: $table.qrCode,
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

  GeneratedColumn<String> get movieTitle => $composableBuilder(
    column: $table.movieTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get showtime =>
      $composableBuilder(column: $table.showtime, builder: (column) => column);

  GeneratedColumn<String> get seatNumbers => $composableBuilder(
    column: $table.seatNumbers,
    builder: (column) => column,
  );

  GeneratedColumn<String> get qrCode =>
      $composableBuilder(column: $table.qrCode, builder: (column) => column);
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
                Value<String> movieTitle = const Value.absent(),
                Value<String> showtime = const Value.absent(),
                Value<String> seatNumbers = const Value.absent(),
                Value<String?> qrCode = const Value.absent(),
              }) => TicketsCompanion(
                id: id,
                movieId: movieId,
                movieTitle: movieTitle,
                showtime: showtime,
                seatNumbers: seatNumbers,
                qrCode: qrCode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String movieId,
                required String movieTitle,
                required String showtime,
                required String seatNumbers,
                Value<String?> qrCode = const Value.absent(),
              }) => TicketsCompanion.insert(
                id: id,
                movieId: movieId,
                movieTitle: movieTitle,
                showtime: showtime,
                seatNumbers: seatNumbers,
                qrCode: qrCode,
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
