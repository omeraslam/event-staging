var TableElement = React.createClass({
    getInitialState: function() {
        return { attendees: this.props.items.items, headers: this.props.table_headers,
        event: this.props.items.event, category: this.props.category }
    },
    getDefaultProps: function() {
        return { attendees: [], event: {}, headers: []}
    },

    componentDidMount: function() {
        var that = this;
        var $table = $(".table-"+this.props.category).tablesorter({
          // Sort on the second column, in ascending order
            theme: 'blue',
            sortList: [[1,0]],
            widgets: [ "filter", "columnSelector"], 
          
            widgetOptions : {
            // use the filter_external option OR use bindSearch function (below)
            // to bind external filters.
            filter_external : '.table-search-'+this.props.category,
            filter_columnFilters: false,
            filter_saveFilters : true,
          
              // target the column selector markup
              columnSelector_container : $('#columnSelector-'+this.props.category),
              // column status, true = display, false = hide
              // disable = do not display on list
              columnSelector_columns : {
                0: 'disable' /* set to disabled; not allowed to unselect it */
              },
              // remember selected columns (requires $.tablesorter.storage)
              columnSelector_saveColumns: true,

              // container layout
              columnSelector_layout : '<label><input type="checkbox">{name}</label>',
              // data attribute containing column name to use in the selector container
              columnSelector_name  : 'data-selector-name',

              /* Responsive Media Query settings */
              // enable/disable mediaquery breakpoints
              columnSelector_mediaquery: true,
              // toggle checkbox name
              columnSelector_mediaqueryName: 'Auto: ',
              // breakpoints checkbox initial setting
              columnSelector_mediaqueryState: true,
              // hide columnSelector false columns while in auto mode
              columnSelector_mediaqueryHidden: true,

              // set the maximum and/or minimum number of visible columns; use null to disable
              columnSelector_maxVisible: null,
              columnSelector_minVisible: null,
              // responsive table hides columns with priority 1-6 at these breakpoints
              // see http://view.jquerymobile.com/1.3.2/dist/demos/widgets/table-column-toggle/#Applyingapresetbreakpoint
              // *** set to false to disable ***
              columnSelector_breakpoints : [ '20em', '30em', '40em', '50em', '60em', '70em' ],
              // data attribute containing column priority
              // duplicates how jQuery mobile uses priorities:
              // http://view.jquerymobile.com/1.3.2/dist/demos/widgets/table-column-toggle/
              columnSelector_priority : 'data-priority',

              // class name added to checked checkboxes - this fixes an issue with Chrome not updating FontAwesome
              // applied icons; use this class name (input.checked) instead of input:checked
              columnSelector_cssChecked : 'checked'
            




    
        }

        });






  
      



    },
    _buildPrintLinkHref: function(e) {
        return this.props.category == 'attendees' ? '/dashboard/print-attendees?event='+ this.props.items.event.event_id : '/dashboard/print?event='+ this.props.items.event.event_id
    },
    _buildDownloadLinkHref: function(e) {
        return this.props.category == 'attendees' ? '/dashboard/print-attendees-csv.csv?event='+ this.props.items.event.event_id : '/dashboard/event.csv?event='+ this.props.items.event.event_id
    },

    render: function() {
        if ( this.props.category == 'attendees' || this.props.category == 'orders') {

        var printLinks = <span>
                        <a href={this._buildPrintLinkHref()} className="btn btn-primary">Print List </a> <a href={this._buildDownloadLinkHref()} className="btn btn-primary">Download CSV</a>
                   </span>;


        } else {
             var printLinks =   '';
        }
        var columnSort = ''
        if ( this.props.category == 'attendees' ||  this.props.category == 'orders') {
            columnSort = <div className="columnSelectorWrapper vertical"><input id={"colSelect-"+this.props.category} type="checkbox" className="hidden" /><label className="columnSelectorButton" htmlFor={"colSelect-"+this.props.category}>Show/Hide Columns</label><div id={"columnSelector-"+ this.props.category} className="columnSelector"></div></div>
        }

        return (
            <div>
            <div className="editor-aside"> 
                <div className="row">
                    <div className="col-md-6">
                        <input className={"search selectable table-search-"+this.props.category} type="search" placeholder={'Search by ' + this.props.category} data-column="all" />
                    </div>

                    <div className="col-md-6 text-right">
                    {columnSort}

                    {printLinks}
                    </div>

                </div>
            </div>

            <div className="editor-panel">





                <table className={"table tablesorter table-"+this.props.category}> 
                            <thead> 
                                <tr> 
                                     {this.state.headers.map(function(header, index){
                                        return <th data-priority={index} key={index}>{header}</th>
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

