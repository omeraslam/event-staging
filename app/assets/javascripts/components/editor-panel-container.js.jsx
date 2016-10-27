var EditorPanelContainer = React.createClass({
    getInitialState: function() {
        return { current_selection: this.props.current_selection,
                 event: this.props.event}
    },
    getDefaultProps: function() {
        return { current_selection: null}
    },

    componentDidMount: function() {
   
    },

    componentWillReceiveProps: function(nextProps) {
      this.setState({
        current_selection: nextProps.current_selection 
      });
    },

    render: function() {

       //if current selection is null, empty state
        if(this.props.current_selection == null) {
            EditorPanelContent = <EditorPanelEmpty />;
        } else {
         EditorPanelContent = <EditorPanel current_selection={this.props.current_selection} event={this.props.event} />
       }

        return (
           <div>
            {EditorPanelContent}
       
            </div>
        )
   } 
});


