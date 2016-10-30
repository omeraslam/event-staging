var TableElement = React.createClass({
    getInitialState: function() {
        return { attendees: this.props.items.items, headers: this.props.table_headers,
        event: this.props.items.event }
    },
    getDefaultProps: function() {
        return { attendees: [], event: {}, headers: []}
    },

    componentDidMount: function() {
        alert('mount it');
        var $table = $(".table-attendees").tablesorter({
          // Sort on the second column, in ascending order
          sortList: [[1,0]],
           widgets: [ "filter"],
               widgetOptions : {
            // use the filter_external option OR use bindSearch function (below)
            // to bind external filters.
            filter_external : '.table-search-attendees',
            filter_columnFilters: false,
            filter_saveFilters : true    
        }

        });

    },
    _buildPrintLinkHref: function(e) {
        return '/dashboard/print?event='+ this.props.items.event.event_id
    },
    _buildDownloadLinkHref: function(e) {
        return '/dashboard/event.csv?event='+ this.props.items.event.event_id
    },

    render: function() {
        return (
            <div>
            <div className="editor-aside"> 
                <div className="row">
                    <div className="col-md-6">
                        <input className="search selectable table-search-attendees" type="search" placeholder="Search attendees" data-column="all" />
                    </div>
                    <div className="col-md-6 text-right">
                        <a href={this._buildPrintLinkHref()} className="btn btn-primary">Print List </a> <a href={this._buildDownloadLinkHref()} className="btn btn-primary">Download CSV</a>
                   </div>
                </div>
            </div>

            <div className="editor-panel">
                <table className="table tablesorter table-attendees"> 
                            <thead> 
                                <tr> 
                                     {this.state.headers.map(function(header, index){
                                        return <th key={index}>{header}</th>
                                    }.bind(this))}   
                                </tr> 
                            </thead> 
                            <tbody>

                                {this.state.attendees.map(function(attendee){
                                return <AttendeeRow key={attendee.id} attendee={attendee}  />
                            }.bind(this))}
                            </tbody> 
                        </table>

                </div>
                </div>

        )
   } 
});

